# ==================== VPC OUTPUTS ====================

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "Public subnet IDs"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "Private subnet IDs"
}

# ==================== EKS OUTPUTS ====================

output "eks_cluster_name" {
  value       = module.eks.cluster_name
  description = "EKS cluster name"
}

output "eks_cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "EKS cluster endpoint"
}

output "eks_cluster_ca" {
  value       = module.eks.cluster_ca_certificate
  sensitive   = true
  description = "EKS cluster CA certificate"
}

output "eks_node_group_id" {
  value       = module.eks.node_group_id
  description = "EKS node group ID"
}

# ==================== AURORA OUTPUTS ====================

output "aurora_cluster_id" {
  value       = module.aurora.cluster_id
  description = "Aurora cluster ID"
}

output "aurora_cluster_endpoint" {
  value       = module.aurora.cluster_endpoint
  description = "Aurora cluster endpoint"
}

output "aurora_reader_endpoint" {
  value       = module.aurora.reader_endpoint
  description = "Aurora reader endpoint"
}

# ==================== SSM PARAMETERS ====================

output "ssm_db_username_param" {
  value       = aws_ssm_parameter.aurora_username.name
  description = "SSM parameter name for DB username"
}

output "ssm_db_password_param" {
  value       = aws_ssm_parameter.aurora_password.name
  description = "SSM parameter name for DB password"
}

output "ssm_db_endpoint_param" {
  value       = aws_ssm_parameter.aurora_endpoint.name
  description = "SSM parameter name for DB endpoint"
}

# ==================== NEXT STEPS ====================

output "kubeconfig_command" {
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
  description = "Command to update kubeconfig"
}

output "get_db_password" {
  value       = "aws ssm get-parameter --name ${aws_ssm_parameter.aurora_password.name} --with-decryption --query Parameter.Value --output text"
  description = "Command to get DB password from SSM"
}
