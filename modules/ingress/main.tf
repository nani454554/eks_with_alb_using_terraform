# provider "helm" {
#   kubernetes {
#     host                   = var.cluster_endpoint
#     token                  = data.aws_eks_cluster_auth.eks.token
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
#   }
# }

# data "aws_eks_cluster" "eks" {
#   name = var.cluster_name
# }

# data "aws_eks_cluster_auth" "eks" {
#   name = var.cluster_name
# }

resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart           = "ingress-nginx"
  namespace       = "ingress-nginx"
  create_namespace = true
  version         = "4.10.1" # Update version as needed

  values = [
    <<EOF
controller:
  service:
    type: LoadBalancer
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-type: "external"
      service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
      service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: "ip"
      service.beta.kubernetes.io/aws-load-balancer-healthcheck-port: "80"
    externalTrafficPolicy: Local
  EOF
  ]
}

data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress-ingress-nginx-controller"  # Adjust if needed
    namespace = "ingress-nginx"
  }
}
