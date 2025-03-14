variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default = "eks-cluster"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default = "ap-south-1"
}