resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role-77"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "eks-cluster-role"
  }
}

# Attach AmazonEKSClusterPolicy
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Attach AmazonEKSVPCResourceController
resource "aws_iam_role_policy_attachment" "eks_vpc_controller" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role-77"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },

      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/${var.oidc_provider}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${var.oidc_provider}:sub" = "system:serviceaccount:kube-system:cluster-autoscaler"
          }
        }
      }

    ]
  })

  tags = {
    Name = "eks-node-role"
  }
}

# Attach AmazonEKSWorkerNodePolicy
resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Attach AmazonEKS_CNI_Policy
resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Attach AmazonEC2ContainerRegistryReadOnly
resource "aws_iam_role_policy_attachment" "ecr_readonly_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Attach AmazonSSMManagedInstanceCore
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach AutoScalingFullAccess
resource "aws_iam_role_policy_attachment" "autoscaling_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
}


# # Create a role for the Cluster Autoscaler
# # Note: This role needs to be manually created and attached to the Cluster Autoscaler service account in the EKS cluster.
resource "aws_iam_role" "cluster_autoscaler" {
  name = "eks-cluster-autoscaler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "cluster_autoscaler_policy" {
  name        = "eks-cluster-autoscaler-policy-77"
  description = "Allows Cluster Autoscaler to manage node groups"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeInstances",
          "ec2:DescribeLaunchTemplateVersions"
        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "cluster_autoscaler_attach" {
  role       = aws_iam_role.eks_node_role.name  # Attach to Node IAM Role
  policy_arn = aws_iam_policy.cluster_autoscaler_policy.arn
}




# data "aws_eks_cluster" "eks" {
#   name = var.eks_cluster_id
# }

# resource "aws_iam_openid_connect_provider" "eks" {
#   url             = https://oidc.eks.ap-south-1.amazonaws.com/id/45AFF6AA88AF3E7F20350010C93A0792
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]
# }

