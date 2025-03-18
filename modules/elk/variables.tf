variable "cluster_name" {}

variable "eks_cluster_id" {
    type        = string
    description = "EKS Cluster ID"
  
}

variable "s3_access_key" {
    type        = string
    description = "AWS Access Key"
    sensitive   = true
}

variable "s3_secret_key" {
    type        = string
    description = "AWS Secret Key"
    sensitive   = true
}