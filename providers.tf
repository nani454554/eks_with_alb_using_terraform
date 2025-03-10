terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.22"
    }
    # tls = {
    #   source  = "hashicorp/tls"
    #   version = ">= 1.1.0, < 4.0.0"
    # }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"  # Use the latest stable version
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  

  }
}

provider "aws" {
  region = "ap-south-1"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  token                  = data.aws_eks_cluster_auth.eks.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
}

data "aws_eks_cluster" "eks" {
  name = module.eks.eks_cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.eks_cluster_id
}
# provider "tls" {
#   proxy {
#     from_env = true
#   }
# }

# provider "kubernetes" {
#   config_path = "~/.kube/config"
# }