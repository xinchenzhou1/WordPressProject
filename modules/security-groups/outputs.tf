output "app-sg"{
    value = aws_security_group.app_security_group
}
output "efs-sg"{
    value = aws_security_group.efs_security_group
}
output "rds-sg"{
    value = aws_security_group.rds_security_group
}
output "web-sg"{
    value = aws_security_group.web_security_group
}