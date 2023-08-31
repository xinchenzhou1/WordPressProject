resource "aws_db_subnet_group" "word-press-db-subnet-group"{
    name = "word-press-db-subnet-group"
    subnet_ids = [var.database_subnet_az1_id, var.var.database_subnet_az2_id]
    tags = {
        Name = "${var.env_prefix}-db-subnet-group"
    }
}

