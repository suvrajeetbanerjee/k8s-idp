variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "km"
}

variable "environment" {
  description = "Environment (dev/stage/prod)"
  type        = string
  validation {
    condition     = can(regex("^(dev|stage|prod)$", var.environment))
    error_message = "Environment must be dev, stage, or prod"
  }
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
}

# EKS Variables
variable "eks_cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "eks_node_instance_types" {
  description = "EC2 instance types for nodes"
  type        = list(string)
}

variable "eks_desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 2
}

variable "eks_min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "eks_max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 5
}

variable "eks_disk_size" {
  description = "Node root volume size in GiB"
  type        = number
  default     = 50
}

# Aurora Variables
variable "aurora_database_name" {
  description = "Aurora database name"
  type        = string
  default     = "kubeplatform"
}

variable "aurora_master_username" {
  description = "Aurora master username"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "aurora_engine_version" {
  description = "Aurora MySQL engine version"
  type        = string
  default     = "8.0.mysql_aurora.3.05.2"
}

variable "aurora_min_capacity" {
  description = "Aurora Serverless v2 minimum ACUs"
  type        = number
  default     = 0.5
}

variable "aurora_max_capacity" {
  description = "Aurora Serverless v2 maximum ACUs"
  type        = number
  default     = 4
}

# Tags
variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
