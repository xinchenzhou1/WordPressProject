data "aws_ami" "latest_linux2_ami"{
    most_recent = true
    owners = ["amazon"]
    filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
    }
    filter {
    name   = "virtualization-type"
    values = ["hvm"]
    }
}
locals {
  DB_NAME=var.rds_db_name
  DB_HOSTNAME=var.rds_db_endpoint
  DB_USERNAME=var.rds_db_username
  DB_PASSWORD=var.rds_db_password
  WP_ADMIN=var.word_press_admin_username
  WP_PASSWORD=var.word_press_admin_password
  WP_EMAIL=var.word_press_admin_email
  LB_HOSTNAME=var.alb_dns_name
  EFS_ID=var.efs_id
  REGION_NAME=var.region
}
resource "aws_launch_template" "wp-launch-template" {
  name = "wp-launch-template"
  image_id = data.aws_ami.latest_linux2_ami.id
  instance_type = "t3.medium"
  vpc_security_group_ids = [var.web_sg_id]
  # user_data = filebase64("userdata.sh")
  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    DB_NAME=local.DB_NAME
    DB_HOSTNAME=local.DB_HOSTNAME
    DB_USERNAME=local.DB_USERNAME
    DB_PASSWORD=local.DB_PASSWORD
    WP_ADMIN=local.WP_ADMIN
    WP_PASSWORD=local.WP_PASSWORD
    WP_EMAIL=local.WP_EMAIL
    LB_HOSTNAME=local.LB_HOSTNAME
    EFS_ID=local.EFS_ID
    REGION_NAME=local.REGION_NAME
    } ))
}

resource "aws_autoscaling_group" "wp-asg" {
    vpc_zone_identifier = [var.app_subnet_1_id, var.app_subnet_2_id]
    desired_capacity   = 2
    max_size           = 4
    min_size           = 2
    target_group_arns = [var.alb_tg_arn]
    health_check_type = "ELB"
    health_check_grace_period = 300
    launch_template {
        id      = aws_launch_template.wp-launch-template.id
        version = "$Latest"
        }
}
resource "aws_autoscaling_policy" "wp-asg-policy" {
  name                   = "word-press-asg-policy"
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
  autoscaling_group_name = aws_autoscaling_group.wp-asg.name
}