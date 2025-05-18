resource "helm_release" "flask_app" {
  name       = "flask"
  chart      = "./../../helm/flask-app"
  namespace  = "default"


  set {
    name  = "image.repository"
    value = "447989883825.dkr.ecr.eu-west-2.amazonaws.com/flask-test"
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  depends_on = [helm_release.nginx_ingress]
}