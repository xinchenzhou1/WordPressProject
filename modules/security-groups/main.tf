# application security group, allow inbound traffic from HTTP
resource "aws_security_group" "app_security_group" {
  name        = "app-instance-sg"
  description = "Allow HTTP Traffic"
  vpc_id      = var.word_press_vpc_id

  ingress {
    description      = "Allow HTTP Inbound Traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-app-sg"
  }
}
# Elastic file system security group, allow inbound application traffic from HTTP, web tier traffic from port 2049
resource "aws_security_group" "efs_security_group" {
  name        = "efs-sg"
  description = "Allow HTTP Traffic from app instance"
  vpc_id      = var.word_press_vpc_id

  ingress {
    description      = "Allow HTTP Inbound Traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups      = [aws_security_group.app_security_group.id]
  }
  
  ingress {
    description      = "Allow HTTP Inbound Traffic"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    security_groups      = [aws_security_group.web_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-efs-sg"
  }
}
# Web tier security group, allow inbound application traffic from HTTP, web tier traffic from port 2049
resource "aws_security_group" "web_security_group" {
  name        = "web-sg"
  description = "Allow HTTP Traffic from app instance"
  vpc_id      = var.word_press_vpc_id

  ingress {
    description      = "Allow HTTP Inbound Traffic from app instance"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups      = [aws_security_group.app_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-web-sg"
  }
}
# Database security group, allow inbound web tier traffic from from port 3306
resource "aws_security_group" "rds_security_group" {
  name        = "rds-sg"
  description = "Allow Traffic from web to rds"
  vpc_id      = var.word_press_vpc_id

  ingress {
    description      = "Allow Traffic from web to rds"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups      = [aws_security_group.web_security_group.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-rds-sg"
  }
}