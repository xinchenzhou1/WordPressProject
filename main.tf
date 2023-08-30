provider "aws" {
    region = var.region_name
}

module "wordpress-network" {
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

# To use output from a module, use the following syntax:
# module.modulename.outputname.attribute