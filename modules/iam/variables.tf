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

# variable "oidc_provider" {
#   description = "OIDC provider for EKS"
#   type        = string
#   default = ""
# }

variable "oidc_issuer_url" {}
variable "oidc_provider_arn" {}
