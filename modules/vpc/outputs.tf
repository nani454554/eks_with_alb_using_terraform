output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}

output "private_subnets_id" {
  value = aws_subnet.private_subnets[*].id
}

output "public_subnets_id" {
  value = aws_subnet.public_subnets[*].id
}

output "eks_control_plane_sg_id" {
  value = aws_security_group.eks_control_plane_sg.id
}

output "eks_nodes_sg_id" {
  value = aws_security_group.eks_nodes_sg.id
}
