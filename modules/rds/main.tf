resource "aws_db_subnet_group" "word-press-db-subnet-group"{
    name = "word-press-db-subnet-group"
    subnet_ids = [var.database_subnet_az1_id, var.database_subnet_az2_id]
    tags = {
        Name = "${var.env_prefix}-db-subnet-group"
    }
}

resource "aws_rds_cluster" "word-press-db-cluster"{
    cluster_identifier = "word-press-db-cluster"
    engine = "aurora-mysql"
    engine_version = "5.7.mysql_aurora.2.11.3"
    availability_zones = [var.az_1, var.az_2]
    # db_cluster_instance_class = "db.t3.small"
    storage_type = ""
    network_type = "IPV4"
    database_name = var.rds_db_name
    master_username = var.rds_master_username
    master_password = var.rds_master_password
    vpc_security_group_ids = [var.database_security_group_id]
    db_subnet_group_name = aws_db_subnet_group.word-press-db-subnet-group.name
    port = "3306"
    storage_encrypted = false
    deletion_protection = false
    skip_final_snapshot = true
    tags = {
        Name = "${var.env_prefix}-rds-db-cluster"
    }
}

resource "aws_rds_cluster_instance" "word-press-db-instance1"{
    identifier = "word-press-db-instance1"
    cluster_identifier = aws_rds_cluster.word-press-db-cluster.id
    instance_class = "db.t3.small"
    engine = aws_rds_cluster.word-press-db-cluster.engine
    engine_version = aws_rds_cluster.word-press-db-cluster.engine_version

    db_subnet_group_name = aws_db_subnet_group.word-press-db-subnet-group.name

    monitoring_interval = "0"
    publicly_accessible = false
    auto_minor_version_upgrade = false
    tags = {
        Name = "${var.env_prefix}-rds-db-instance-1"
    }
}
resource "aws_rds_cluster_instance" "word-press-db-instance2"{
    identifier = "word-press-db-instance2"
    cluster_identifier = aws_rds_cluster.word-press-db-cluster.id
    instance_class = "db.t3.small"
    engine = aws_rds_cluster.word-press-db-cluster.engine
    engine_version = aws_rds_cluster.word-press-db-cluster.engine_version

    db_subnet_group_name = aws_db_subnet_group.word-press-db-subnet-group.name

    monitoring_interval = "0"
    publicly_accessible = false
    auto_minor_version_upgrade = false
    tags = {
        Name = "${var.env_prefix}-rds-db-instance-2"
    }
}
