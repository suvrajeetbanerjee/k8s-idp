variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "aurora_security_group_id" {
  type = string
}

variable "aurora_engine_version" {
  type = string
}

variable "aurora_serverless_v2_scaling_min" {
  type = number
}

variable "aurora_serverless_v2_scaling_max" {
  type = number
}

variable "aurora_backup_retention_days" {
  type = number
}

variable "aurora_master_username" {
  type      = string
  sensitive = true
}

variable "aurora_master_password" {
  type      = string
  sensitive = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
