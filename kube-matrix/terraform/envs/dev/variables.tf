# ==================== CORE VARIABLES ====================

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "ap-south-1"
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "km"
}

variable "environment" {
  type        = string
  description = "Environment (dev/stage/prod)"
  default     = "dev"
}

# ==================== VPC VARIABLES ====================

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDR blocks"
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDR blocks"
  default     = ["10.10.10.0/24", "10.10.11.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability zones"
  default     = ["ap-south-1a", "ap-south-1b"]
}

# ==================== EKS VARIABLES ====================

variable "eks_cluster_version" {
  type        = string
  description = "EKS cluster version"
  default     = "1.29"
}

variable "node_group_desired_size" {
  type        = number
  description = "Desired number of nodes"
  default     = 2
}

variable "node_group_min_size" {
  type        = number
  description = "Minimum number of nodes"
  default     = 1
}

variable "node_group_max_size" {
  type        = number
  description = "Maximum number of nodes"
  default     = 5
}

variable "node_instance_type" {
  type        = string
  description = "EC2 instance type for nodes"
  default     = "t3.medium"
}

# ==================== AURORA VARIABLES ====================

variable "aurora_engine_version" {
  type        = string
  description = "Aurora MySQL engine version"
  default     = "8.0.mysql_aurora.3.02.0"
}

variable "aurora_serverless_v2_scaling_min" {
  type        = number
  description = "Min ACUs for Aurora Serverless V2"
  default     = 0.5
}

variable "aurora_serverless_v2_scaling_max" {
  type        = number
  description = "Max ACUs for Aurora Serverless V2"
  default     = 4
}

variable "aurora_backup_retention_days" {
  type        = number
  description = "Backup retention period"
  default     = 7
}

variable "aurora_master_username" {
  type        = string
  description = "Master username"
  default     = "admin"
  sensitive   = true
}

# ==================== TAGS ====================

variable "tags" {
  type        = map(string)
  description = "Additional tags"
  default = {
    Component = "infrastructure"

}
}
