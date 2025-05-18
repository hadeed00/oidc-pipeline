data "aws_caller_identity" "current" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "eks-vpc"
  cidr = var.vpc_cidr

  azs                  = ["${var.region}a", "${var.region}b"]
  public_subnets       = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets      = ["10.0.11.0/24", "10.0.12.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true

  map_public_ip_on_launch = true 

  # Enable NAT Gateway
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false
  
  # Add required tags for EKS
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets
  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      desired_size = 1
      max_size     = 2
      min_size     = 1
      
      instance_types = ["t3.small"]
      
      # Add IAM role configuration
      iam_role_additional_policies = {
        AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        AmazonEKS_CNI_Policy              = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      }
      
      tags = {
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      }
    }

    ingress_nodes = {
      name           = "ingress-nodes"
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 3
      desired_size   = 1

      # Use public subnets for ingress nodes
      subnet_ids = module.vpc.public_subnets

      # Special taints and labels


      labels = {
        role = "ingress"
      }

      # IAM role with additional permissions
      iam_role_additional_policies = {
        AmazonEC2FullAccess = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
      }

      # AMI and capacity settings
      ami_type       = "AL2_x86_64"
      capacity_type  = "ON_DEMAND"

      # Required for ALB controller
      update_config = {
        max_unavailable = 1
      }
    }
  }

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.iam_user_name}"
      username = var.iam_user_name
      groups   = ["system:masters"]
    }
  ]

  cluster_endpoint_public_access   = true
  cluster_endpoint_private_access  = true

  # Add cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                  = "tcp"
      from_port                 = 1025
      to_port                   = 65535
      type                      = "egress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }
}