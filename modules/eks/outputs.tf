output "eks_cluster_id" {
  value = aws_eks_cluster.eks.id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_certificate_authority" {
  description = "EKS Cluster Certificate Authority"
  value       = aws_eks_cluster.eks.certificate_authority[0].data
}

output "nodegroup1_id" {
  value = aws_eks_node_group.nodegroup1.id
}

output "nodegroup2_id" {
  value = aws_eks_node_group.nodegroup2.id
}

output "worker_node_asg_names" {
  value = [
    aws_eks_node_group.nodegroup1.resources[0].autoscaling_groups[0].name,
    aws_eks_node_group.nodegroup2.resources[0].autoscaling_groups[0].name
  ]
}

output "worker_node_ips" {
  description = "List of private IPs of worker nodes"
  value       = data.aws_instances.eks_nodes.private_ips
}

output "nodegroup1_name" {
  description = "EKS Node Group 1 Name"
  value       = aws_eks_node_group.nodegroup1.node_group_name
}

output "nodegroup2_name" {
  description = "EKS Node Group 2 Name"
  value       = aws_eks_node_group.nodegroup2.node_group_name
}

output "eks_oidc_issuer_url" {
  description = "OIDC Issuer URL for the EKS cluster"
  value       = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

output "eks_oidc_provider_arn" {
  description = "OIDC Provider ARN"
  value       = aws_iam_openid_connect_provider.eks.arn
}
