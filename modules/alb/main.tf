resource "aws_lb" "word-press-alb" {
  name               = "word-press-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = [var.public_subnet_1_id, var.public_subnet_2_id]

  enable_deletion_protection = false

  tags = {
    Name: "${var.env_prefix}-application-load-balancer"
  }
}

resource "aws_lb_target_group" "word-press-http-tg" {
  name     = "word-press-http-tg"
  port     = 80
  protocol = "HTTP"
  protocol_version = "HTTP1"
  vpc_id   = var.vpc_id
  target_type = "instance"

  health_check {
    path = "/wp-login.php"
    healthy_threshold = 2
    timeout = 50
    interval = 60
    unhealthy_threshold = 10
    matcher = 200
  }
  tags = {
    Name: "${var.env_prefix}-application-load-balancer-http-tg"
  }
}

resource "aws_lb_listener" "word_press_http_listener" {
  load_balancer_arn = aws_lb.word-press-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.word-press-http-tg.arn
  }
}