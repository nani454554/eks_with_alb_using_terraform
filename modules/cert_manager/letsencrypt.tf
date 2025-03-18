resource "kubectl_manifest" "letsencrypt_issuer" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  
spec:
  acme:
    email: "nikhilb@sidgs.com"  #issue with email need to change origin domainemail
    server: "https://acme-v02.api.letsencrypt.org/directory"
    privateKeySecretRef:
      name: letsencrypt-prod-key
    solvers:
    - http01:
        ingress:
          class: nginx
YAML

depends_on = [helm_release.cert_manager]
}
