variable "eks_cluster_role_name" {
  default = "eks-cluster-role-77"
}

variable "eks_node_role_name" {
  default = "eks-node-role-77"
}

variable "eks_cluster_id" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
  default = "942788320122"
}

variable "oidc_provider" {
  description = "OIDC provider for EKS"
  type        = string
  default = "https://oidc.eks.ap-south-1.amazonaws.com/id/45AFF6AA88AF3E7F20350010C93A0792"
}
