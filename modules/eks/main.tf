resource "aws_eks_cluster" "eks" {
  name     = var.eks_cluster_name
  role_arn = var.eks_role_arn
  version  = var.kubernetes_version  # Kubernetes version

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  enabled_cluster_log_types = var.enable_logging ? ["api", "audit", "authenticator", "controllerManager", "scheduler"] : []

  tags = {
    Name        = var.eks_cluster_name
    Environment = var.environment
  }
}

resource "aws_eks_node_group" "nodegroup1" {
  cluster_name    = var.eks_cluster_name
  node_group_name = "nodegroup1"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    min_size     = 1
    max_size     = 4
    desired_size = 1
  }

  ami_type       = "AL2_x86_64"  # Amazon Linux 2 (or custom AMI)
  instance_types = ["t3.medium"]

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name        = "eks-nodegroup1"
    Environment = "production"
  }

#   launch_template {
#     id      = module.lauch_templates.eks_managed_1_id
#     version = module.lauch_templates.eks_managed_1_version
#   }

  depends_on = [aws_eks_cluster.eks]
}

resource "aws_eks_node_group" "nodegroup2" {
  cluster_name    = var.eks_cluster_name
  node_group_name = "nodegroup2"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    min_size     = 1
    max_size     = 4
    desired_size = 1
  }

  ami_type       = "AL2_x86_64"
  instance_types = ["t3.medium"]

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name        = "eks-nodegroup2"
    Environment = "production"
  }

#   launch_template {
#     id      = module.lauch_templates.eks_managed_1_id
#     version = module.lauch_templates.eks_managed_1_version
#   }

  depends_on = [aws_eks_cluster.eks]
}

