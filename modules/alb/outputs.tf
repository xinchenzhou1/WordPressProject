output "word-press-alb"{
    value = aws_lb.word-press-alb
}
output "word-press-alb-tg"{
    value = aws_lb_target_group.word-press-http-tg
}