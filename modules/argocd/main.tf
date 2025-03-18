resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "5.51.5" # Check latest version from Helm repo

  create_namespace = true

  values = [
    <<EOF
    server:
      service:
        type: LoadBalancer
    EOF
  ]
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.eks_cluster_name
  depends_on = [ var.eks_cluster_id ]
}

data "aws_eks_cluster" "eks" {
  name = var.eks_cluster_name
  depends_on = [ var.eks_cluster_id ]
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  }
}
