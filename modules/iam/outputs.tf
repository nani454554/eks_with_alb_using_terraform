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

output "cluster_loadbalancer_role_arn" {
  description = "IAM role ARN for AWS Load Balancer Controller"
  value       = aws_iam_role.alb_controller_role.arn
}

# output "oidc_provider_arn" {
#   value = aws_iam_openid_connect_provider.eks.arn
# }



