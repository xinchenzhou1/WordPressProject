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
# http target group for ALB
resource "aws_lb_target_group" "word-press-http-tg" {
  name     = "word-press-http-tg"
  port     = 80
  protocol = "HTTP"
  # Send requests to targets using HTTP/1.1. Supported when the request protocol is HTTP/1.1 or HTTP/2.
  protocol_version = "HTTP1"
  vpc_id   = var.vpc_id
  target_type = "instance"

  health_check {
    path = "/wp-login.php"
    protocol = "HTTP"
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

# https target group for ALB
# resource "aws_lb_target_group" "word-press-https-tg" {
#   name     = "word-press-https-tg"
#   port     = 443
#   protocol = "HTTPS"
#   # Send requests to targets using HTTP/1.1. Supported when the request protocol is HTTP/1.1 or HTTP/2.
#   protocol_version = "HTTP1"
#   vpc_id   = var.vpc_id
#   target_type = "instance"

#   health_check {
#     path = "/wp-login.php"
#     protocol = "HTTPS"
#     healthy_threshold = 2
#     timeout = 50
#     interval = 60
#     unhealthy_threshold = 10
#     matcher = 200
#   }
#   tags = {
#     Name: "${var.env_prefix}-application-load-balancer-https-tg"
#   }
# }

# ALB listener for HTTP traffic
resource "aws_lb_listener" "word_press_http_listener" {
  load_balancer_arn = aws_lb.word-press-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.word-press-http-tg.arn
  }
}

# # ALB listener for HTTPS traffic
# resource "aws_lb_listener" "word_press_https_listener" {
#   load_balancer_arn = aws_lb.word-press-alb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   certificate_arn = ""
#   ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.word-press-https-tg.arn
#   }
# }