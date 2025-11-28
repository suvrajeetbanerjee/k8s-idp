locals {
  name_prefix = "${var.project}-${var.environment}"
}

resource "aws_db_subnet_group" "main" {
  name       = "${local.name_prefix}-aurora-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, { Name = "${local.name_prefix}-aurora-subnet-group" })
}

resource "aws_rds_cluster" "main" {
  cluster_identifier      = "${local.name_prefix}-aurora-mysql"
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.08.2"
  database_name           = "kubeplatform"
  master_username         = var.aurora_master_username
  master_password         = var.aurora_master_password
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [var.aurora_security_group_id]
  backup_retention_period = var.aurora_backup_retention_days
  storage_encrypted       = true
  skip_final_snapshot     = false

  serverlessv2_scaling_configuration {
    max_capacity = var.aurora_serverless_v2_scaling_max
    min_capacity = var.aurora_serverless_v2_scaling_min
  }

  tags = merge(var.tags, { Name = "${local.name_prefix}-aurora-cluster" })
}

resource "aws_rds_cluster_instance" "main" {
  cluster_identifier      = aws_rds_cluster.main.id
  instance_class          = "db.serverless"
  engine                  = aws_rds_cluster.main.engine
  engine_version          = "8.0.mysql_aurora.3.08.2"
  publicly_accessible     = false

  tags = merge(var.tags, { Name = "${local.name_prefix}-aurora-instance-1" })
}

output "cluster_id" { value = aws_rds_cluster.main.id }
output "cluster_endpoint" { value = aws_rds_cluster.main.endpoint }
output "reader_endpoint" { value = aws_rds_cluster.main.reader_endpoint }
output "master_username" {
  value     = aws_rds_cluster.main.master_username
  sensitive = true
}


