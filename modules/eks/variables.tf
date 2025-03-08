variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "eks_role_arn" {
  description = "IAM Role ARN for the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.31"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the EKS cluster"
  type        = list(string)
}

variable "enable_logging" {
  description = "Enable EKS logging"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}


variable "node_role_arn" {
  description = "IAM Role ARN for worker nodes"
  type        = string
}


