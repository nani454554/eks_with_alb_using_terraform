
# provider "kubectl" {
#   host                   = data.aws_eks_cluster.eks.endpoint
#   token                  = data.aws_eks_cluster_auth.eks.token
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
# }

resource "kubectl_manifest" "nginx_ingress_resource" {
  yaml_body = file("${path.module}/ingress.yaml")

  depends_on = [helm_release.nginx_ingress]
}

