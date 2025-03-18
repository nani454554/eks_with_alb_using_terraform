resource "kubectl_manifest" "nginx_namespace" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: nani-app
YAML
}

resource "kubectl_manifest" "argocd_application" {
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nginx-application
  namespace: argocd
spec:
  project: default
  source:
    repoURL: "https://github.com/nani454554/nginx-app-repo.git"
    targetRevision: main
    path: manifests
  destination:
    server: https://kubernetes.default.svc
    namespace: nani-app
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
YAML
}



# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.eks.endpoint
#   token                  = data.aws_eks_cluster_auth.eks.token
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
# }

# data "aws_eks_cluster" "eks" {
#   name = var.cluster_name
# }

# data "aws_eks_cluster_auth" "eks" {
#   name = var.cluster_name
# }





























# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.eks.endpoint
#   token                  = data.aws_eks_cluster_auth.eks.token
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
# }

# data "aws_eks_cluster" "eks" {
#   name = var.cluster_name
# }

# data "aws_eks_cluster_auth" "eks" {
#   name = var.cluster_name
# }

# resource "kubernetes_namespace" "nginx" {
#   metadata {
#     name = "nginx-app"
#   }
# }

# resource "kubernetes_deployment" "nginx" {
#   metadata {
#     name      = "nginx-deployment"
#     namespace = kubernetes_namespace.nginx.metadata[0].name
#     labels = {
#       app = "nginx"
#     }
#   }

#   spec {
#     replicas = 2

#     selector {
#       match_labels = {
#         app = "nginx"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "nginx"
#         }
#       }

#       spec {
#         container {
#           name  = "nginx"
#           image = "nginx:latest"

#           port {
#             container_port = 80
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service" "nginx" {
#   metadata {
#     name      = "nginx-service"
#     namespace = kubernetes_namespace.nginx.metadata[0].name
#   }

#   spec {
#     selector = {
#       app = "nginx"
#     }

#     port {
#       protocol    = "TCP"
#       port        = 80
#       target_port = 80
#     }

#     type = "LoadBalancer"
#   }
# }
