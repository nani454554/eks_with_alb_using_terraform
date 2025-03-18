output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

output "node_instance_profile_name" {
  value = aws_iam_role.eks_node_role.name
}

output "cluster_autoscaler_role_arn" {
    value = aws_iam_role.cluster_autoscaler.arn
  
}

# output "eks_oidc_provider_arn" {
#   description = "OIDC provider ARN for EKS"
#   value       = aws_iam_openid_connect_provider.eks.arn
# }
