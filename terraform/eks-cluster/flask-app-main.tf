resource "helm_release" "flask_app" {
  name       = "flask"
  chart      = "./../../helm/flask-app"
  namespace  = "default"

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  depends_on = [helm_release.nginx_ingress]
}