resource "helm_release" "flask_app" {
  name       = "flask"
  chart      = "./../../helm/flask-app"
  namespace  = "default"

  values     = [yamlencode(local.chart_values)]
  depends_on = [helm_release.nginx_ingress]
}

locals {
  chart_values = {
    service = {
      type = "ClusterIP"
    }
  }
}