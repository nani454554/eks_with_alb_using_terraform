provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  }
}

# Fetch EKS Cluster Details
data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_name
  depends_on = [var.eks_cluster_id] 
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.eks_cluster_name
}

resource "helm_release" "aws_lb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.7.1" # Check latest version

  values = [
    <<EOF
serviceAccount:
  create: true
  name: aws-load-balancer-controller
  annotations:
    eks.amazonaws.com/role-arn: ${var.alb_controller_role}

clusterName: ${var.eks_cluster_name}

region: ${var.aws_region}

vpcId: ${var.vpc_id}

enableShield: false
enableWaf: false
enableWafv2: false
enableServiceMutatorWebhook: false
EOF
  ]
}