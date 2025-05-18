resource "helm_release" "flask_app" {
  name       = "flask"
  chart      = "./../../helm/flask-app"
  namespace  = "default"

  depends_on = [helm_release.nginx_ingress]
}

locals {
  chart_values = {
    service = {
      type = "ClusterIP"
    }
  }
}