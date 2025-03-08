output "nginx_lb_hostname" {
  value = try(data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname, "")
}
