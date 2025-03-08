resource "kubectl_manifest" "nginx_ingress_resource" {
  yaml_body = file("${path.module}/ingress.yaml")

  depends_on = [helm_release.nginx_ingress]
}

