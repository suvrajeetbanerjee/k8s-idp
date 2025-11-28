aws_region = "ap-south-1"
project    = "km"
environment = "dev"

vpc_cidr             = "10.10.0.0/16"
public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24"]
private_subnet_cidrs = ["10.10.10.0/24", "10.10.11.0/24"]
azs                  = ["ap-south-1a", "ap-south-1b"]

eks_cluster_version        = "1.29"
node_group_desired_size    = 2
node_group_min_size        = 1
node_group_max_size        = 5
node_instance_type         = "t3.medium"

aurora_engine_version = "8.0.mysql_aurora.3.08.2"
aurora_serverless_v2_scaling_min = 0.5
aurora_serverless_v2_scaling_max = 4
aurora_backup_retention_days    = 7
aurora_master_username          = "admin"

tags = {
  Component = "infrastructure"
  Team      = "devops"
}
