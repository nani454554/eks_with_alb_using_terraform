output "eks_cluster_id" {
  value = aws_eks_cluster.eks.id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "nodegroup1_id" {
  value = aws_eks_node_group.nodegroup1.id
}

output "nodegroup2_id" {
  value = aws_eks_node_group.nodegroup2.id
}
