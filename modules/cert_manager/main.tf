resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  # namespace  = kubernetes_namespace.cert_manager.metadata[0].name
  version    = "v1.17.1"

  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "extraArgs[0]"
    value = "--enable-certificate-owner-ref=true"
  }
  # depends_on = [kubernetes_namespace.cert_manager]
}


