module "vpc" {
  source = "./modules/vpc"

  project              = var.project
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs

  tags = var.tags
}

# ==================== AURORA ====================
module "aurora" {
  source = "./modules/aurora"

  project            = var.project
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  database_name      = var.aurora_database_name
  master_username    = var.aurora_master_username
  engine_version     = var.aurora_engine_version
  min_capacity       = var.aurora_min_capacity
  max_capacity       = var.aurora_max_capacity

  # Will update this after EKS nodes are created
  allowed_security_group_ids = [module.eks.node_security_group_id]

  tags = var.tags

  depends_on = [module.vpc]
}

# ==================== EKS ====================
module "eks" {
  source = "./modules/eks"

  project             = var.project
  environment         = var.environment
  cluster_version     = var.eks_cluster_version
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  public_subnet_ids   = module.vpc.public_subnet_ids
  node_instance_types = var.eks_node_instance_types
  desired_size        = var.eks_desired_size
  min_size            = var.eks_min_size
  max_size            = var.eks_max_size
  disk_size           = var.eks_disk_size
  aurora_db_sg_id     = module.aurora.security_group_id

  tags = var.tags

  depends_on = [module.vpc, module.aurora]
}

# ==================== OUTPUTS ====================
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "aurora_endpoint" {
  value = module.aurora.writer_endpoint
}

output "aurora_db_sg_id" {
  value = module.aurora.security_group_id
}

output "db_username_ssm_param" {
  value = module.aurora.db_username_ssm_param
}

output "db_password_ssm_param" {
  value = module.aurora.db_password_ssm_param
}
