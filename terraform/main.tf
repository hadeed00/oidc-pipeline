module "eks_cluster" {
  source = "./eks-cluster"
}

module "nginx_ingress" {
  source = "./eks-cluster/nginx"
  depends_on = [module.eks_cluster]
}

module "flask_app" {
  source = "./eks-cluster/flask-app"
  depends_on = [module.nginx_ingress]
}