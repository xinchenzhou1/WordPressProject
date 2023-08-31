provider "aws" {
    region = var.region_name
}

module "word-press-network" {
    source = "./modules/network"
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

module "word-press-security-groups"{
    source = "./modules/security-groups"
    word_press_vpc_id = module.word-press-network.word-press-vpc.id
    env_prefix = var.env_prefix
}

module "word-press-database"{
    source = "./modules/rds"
    word_press_vpc_id = module.word-press-network.word-press-vpc.id
    database_subnet_az1_id = module.word-press-network.database-subnet-1.id
    database_subnet_az2_id = module.word-press-network.database-subnet-2.id
    database_security_group_id = module.word-press-security-groups.rds-sg.id
}

# To use output from a module, use the following syntax:
# module.modulename.outputname.attribute