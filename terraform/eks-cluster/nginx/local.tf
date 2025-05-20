locals {
  chart_values = {
    controller = {
      service = {
        annotations = {
          "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
        }
        type    = "LoadBalancer"
        
      }
    }
  }
}