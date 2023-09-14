variable vpc_cidr_block{
    type = string
    description = "IPV4 cidr block of the VPC"
    default = "10.0.0.0/16"
}
variable public_subnet_1_cidr_block{
    type = string
    description = "IPV4 cidr block of the public Subnet 1"
    default = "10.0.0.0/24"    
}
variable public_subnet_2_cidr_block{
    type = string
    description = "IPV4 cidr block of the public Subnet 2"
    default = "10.0.1.0/24" 
}
variable app_subnet_1_cidr_block{
    type = string
    description = "IPV4 cidr block of the application Subnet 1"
    default = "10.0.2.0/24" 
}
variable app_subnet_2_cidr_block{
    type = string
    description = "IPV4 cidr block of the application Subnet 2"
    default = "10.0.3.0/24" 
}
variable database_subnet_1_cidr_block{
    type = string
    description = "IPV4 cidr block of the rds database Subnet 1"
    default = "10.0.4.0/24" 
}

variable database_subnet_2_cidr_block{
    type = string
    description = "IPV4 cidr block of the rds database Subnet 2"
    default = "10.0.5.0/24"
}
variable env_prefix{
    type = string
    description = "Environment prefix used for tagging"
    default = "WordPressApp"
}
variable region_name{
    type = string
    description = "aws resources region"
    default = "ca-central-1"
}
variable az_1{
    type = string
    description = "aws availability zone 1"
    default = "ca-central-1a"
}
variable az_2{
    type = string
    description = "aws availability zone 2"
    default = "ca-central-1a"
}
variable ec2_instance_type{
    type = string
    description = "aws ec2 instance type"
    default = "t3.medium"
}
variable db_name{
    type = string
    description = "Name of the rds database"
    default = "WPDatabase"
}
# Sensitivite Information: To be filled in terraform.tfvars file
variable db_master_username{
    type = string
    description = "RDS database master username, must contain only alphanumeric characters (minimum 8; maximum 16)"
    default = ""
    sensitive = true
}
variable db_master_password{
    type = string
    description = "RDS database master password (minimum 6)"
    default = ""
    sensitive = true
}
variable wp_admin_username{
    type = string
    description = "word press admin username"
    default = ""
    sensitive = true
}
variable wp_admin_password{
    type = string
    description = "word press admin password"
    default = ""
    sensitive = true
}
variable wp_admin_email{
    type = string
    description = "word press admin email"
    default = "" 
    sensitive = true
}
