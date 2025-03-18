variable "cluster_autoscaler_role_arn" {
  description = "IAM Role ARN for Cluster Autoscaler"
  type        = string
}

variable "eks_cluster_id" {
  description = "EKS cluster ID"
  type        = string
}

# variable "cluster_autoscaler_oidc_arn" {
#   description = "OIDC provider ARN for EKS"
#   type        = string
# }
# variable "eks_oidc_provider_arn" {
#   description = "OIDC provider ARN for EKS"
#   type        = string
  
# }