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

  depends_on = [var.eks_role_arn]
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

resource "aws_eks_addon" "metrics_server" {
  cluster_name      = var.eks_cluster_name
  addon_name        = "eks-pod-identity-agent"
  addon_version     = "v1.3.5-eksbuild.2" # Check latest version from AWS
  resolve_conflicts_on_create = "OVERWRITE"
   resolve_conflicts_on_update = "PRESERVE"

  depends_on = [aws_eks_cluster.eks]
}

# Fetch Auto Scaling Group Names
data "aws_autoscaling_groups" "eks_asgs" {
  names = [
    aws_eks_node_group.nodegroup1.resources[0].autoscaling_groups[0].name,
    aws_eks_node_group.nodegroup2.resources[0].autoscaling_groups[0].name
  ]
}

data "aws_instances" "eks_nodes" {
  filter {
    name   = "tag:eks:nodegroup-name"
    values = [
      aws_eks_node_group.nodegroup1.node_group_name,
      aws_eks_node_group.nodegroup2.node_group_name
    ]
  }
}


# data "aws_iam_openid_connect_provider" "eks" {
#   url = "https://oidc.eks.ap-south-1.amazonaws.com/id/A18800737B868E3B70A8E37F8445236A"
# }

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

data "tls_certificate" "oidc" {
  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

