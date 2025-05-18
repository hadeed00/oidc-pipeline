resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.7.1"  
  values = [yamlencode(local.chart_values_nginx)]
}

locals {
  chart_values_nginx = {
    controller = {
      service = {
        type    = "LoadBalancer"
        annotations = {
          "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
        }
      }
    }
  }
}