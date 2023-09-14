provider "aws" {
    region = var.region_name
}

# Network module, includes VPC, subnets, nat gateways, route tables, IGW configurations
module "word-press-network" {
    source = "./modules/network"
    # variables from variables.tf
    vpc_cidr_block = var.vpc_cidr_block
    public_subnet_1_cidr_block = var.public_subnet_1_cidr_block
    public_subnet_2_cidr_block = var.public_subnet_2_cidr_block
    app_subnet_1_cidr_block = var.app_subnet_1_cidr_block
    app_subnet_2_cidr_block = var.app_subnet_2_cidr_block
    database_subnet_1_cidr_block = var.database_subnet_1_cidr_block
    database_subnet_2_cidr_block = var.database_subnet_2_cidr_block
    az_1 = var.az_1
    az_2 = var.az_2
    env_prefix = var.env_prefix
}
# Security group module, includes application, web, efs, rds security groups
module "word-press-security-groups"{
    source = "./modules/security-groups"
    # network module output variables
    word_press_vpc_id = module.word-press-network.word-press-vpc.id
    # variables from variables.tf
    env_prefix = var.env_prefix
}
# Database module, includes creation for rds cluster, instances, and rds subnet groups
module "word-press-database"{
    source = "./modules/rds"
    # network module output variables
    word_press_vpc_id = module.word-press-network.word-press-vpc.id
    database_subnet_az1_id = module.word-press-network.database-subnet-1.id
    database_subnet_az2_id = module.word-press-network.database-subnet-2.id
    # security group module output variable
    database_security_group_id = module.word-press-security-groups.rds-sg.id
    # variables from variables.tf
    az_1 = var.az_1
    az_2 = var.az_2
    rds_master_username = var.db_master_username
    rds_master_password = var.db_master_password
    rds_db_name = var.db_name
    env_prefix = var.env_prefix
}
# Elastic file system module
module "word-press-elastic-file-system"{
    source = "./modules/efs"
    # network module output variables
    app_subnet_1_id = module.word-press-network.app-subnet-1.id
    app_subnet_2_id = module.word-press-network.app-subnet-2.id
    # security group module output variable
    efs_sg_id = module.word-press-security-groups.efs-sg.id

    env_prefix = var.env_prefix
}
# Application load balancer, target group and listener module
module "word-press-application-load-balancer"{
    source = "./modules/alb"
    # network module output variables
    vpc_id = module.word-press-network.word-press-vpc.id
    public_subnet_1_id = module.word-press-network.public-subnet-1.id
    public_subnet_2_id = module.word-press-network.public-subnet-2.id
    # application load balancer module output variable
    alb_sg_id = module.word-press-security-groups.app-sg.id

    env_prefix = var.env_prefix
}
# Auto scaling group and launch template module
module "word-press-web-server"{
    source = "./modules/web-server"
    # database module output variables
    rds_db_name = module.word-press-database.database-cluster.database_name
    rds_db_endpoint = module.word-press-database.database-cluster.endpoint
    rds_db_username = module.word-press-database.database-cluster.master_username
    # application load balancer module output variables
    alb_dns_name = module.word-press-application-load-balancer.word-press-alb.dns_name
    alb_tg_arn = module.word-press-application-load-balancer.word-press-alb-tg.arn
    # elastic file system module output variable
    efs_id = module.word-press-elastic-file-system.word-press-efs-file-system.id
    # security group module output variable
    web_sg_id = module.word-press-security-groups.web-sg.id
    # network module output variables
    app_subnet_1_id = module.word-press-network.app-subnet-1.id
    app_subnet_2_id = module.word-press-network.app-subnet-2.id
    # variables from variables.tf
    web_server_ec2_instance_type = var.ec2_instance_type
    region = var.region_name
    env_prefix = var.env_prefix
    rds_db_password = var.db_master_password
    word_press_admin_username = var.wp_admin_username
    word_press_admin_password = var.wp_admin_password
    word_press_admin_email = var.wp_admin_email
}
