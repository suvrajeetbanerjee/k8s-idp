# ==================== LOCAL VARIABLES ====================

locals {
  name_prefix = "${var.project}-${var.environment}"
}

# ==================== RANDOM PASSWORD FOR AURORA ====================

resource "random_password" "aurora_master_password" {
  length  = 16
  special = false
  override_special = ""
}


# ==================== SECURITY GROUPS ====================

resource "aws_security_group" "eks_nodes" {
  name        = "${local.name_prefix}-sg-eks-nodes"
  description = "Security group for EKS nodes"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "udp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-sg-eks-nodes"
  }
}

resource "aws_security_group" "aurora" {
  name        = "${local.name_prefix}-sg-aurora"
  description = "Security group for Aurora MySQL"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
    description     = "MySQL from EKS nodes"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-sg-aurora"
  }
}

# ==================== VPC MODULE ====================

module "vpc" {
  source = "../../modules/vpc"

  project                = var.project
  environment            = var.environment
  vpc_cidr               = var.vpc_cidr
  public_subnet_cidrs    = var.public_subnet_cidrs
  private_subnet_cidrs   = var.private_subnet_cidrs
  azs                    = var.azs
  tags                   = var.tags
}

# ==================== AURORA MODULE ====================

module "aurora" {
  source = "../../modules/aurora"

  project                      = var.project
  environment                  = var.environment
  vpc_id                       = module.vpc.vpc_id
  private_subnet_ids           = module.vpc.private_subnet_ids
  aurora_security_group_id     = aws_security_group.aurora.id
  aurora_engine_version        = var.aurora_engine_version
  aurora_serverless_v2_scaling_min = var.aurora_serverless_v2_scaling_min
  aurora_serverless_v2_scaling_max = var.aurora_serverless_v2_scaling_max
  aurora_backup_retention_days = var.aurora_backup_retention_days
  aurora_master_username       = var.aurora_master_username
  aurora_master_password       = random_password.aurora_master_password.result
  tags                         = var.tags
}

# ==================== EKS MODULE ====================

module "eks" {
  source = "../../modules/eks"

  project                    = var.project
  environment                = var.environment
  vpc_id                     = module.vpc.vpc_id
  private_subnet_ids         = module.vpc.private_subnet_ids
  eks_cluster_version        = var.eks_cluster_version
  node_group_desired_size    = var.node_group_desired_size
  node_group_min_size        = var.node_group_min_size
  node_group_max_size        = var.node_group_max_size
  node_instance_type         = var.node_instance_type
  node_security_group_ids    = [aws_security_group.eks_nodes.id]
  tags                       = var.tags
}

# ==================== SSM PARAMETERS FOR CREDENTIALS ====================

resource "aws_ssm_parameter" "aurora_username" {
  name  = "/${local.name_prefix}/db/username"
  type  = "String"
  value = module.aurora.master_username

  tags = {
    Name = "${local.name_prefix}-aurora-username"
  }
}

resource "aws_ssm_parameter" "aurora_password" {
  name  = "/${local.name_prefix}/db/password"
  type  = "SecureString"
  value = random_password.aurora_master_password.result

  tags = {
    Name = "${local.name_prefix}-aurora-password"
  }
}

resource "aws_ssm_parameter" "aurora_endpoint" {
  name  = "/${local.name_prefix}/db/endpoint"
  type  = "String"
  value = module.aurora.cluster_endpoint

  tags = {
    Name = "${local.name_prefix}-aurora-endpoint"
  }
}

resource "aws_ssm_parameter" "aurora_database" {
  name  = "/${local.name_prefix}/db/database"
  type  = "String"
  value = "kubeplatform"

  tags = {
    Name = "${local.name_prefix}-aurora-database"
  }
}
