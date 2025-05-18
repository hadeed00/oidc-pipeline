variable "region" {
  default = "eu-west-2"
}

variable "cluster_name" {
  default = "flask-eks-cluster"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "iam_user_name" {
  description = "IAM user name for EKS cluster access"
  type        = string
  default     = "devops-admin"
}