module "vpc" {
  source          = "./modules/vpc"
  cluster_name = var.cluster_name
  vpc_name        = "eks-cluster-vpc"
  vpc_cidr        = "10.0.0.0/16"
  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

module "iam" {
  source                = "./modules/iam"
  eks_cluster_role_name = "eks-cluster-role-77"
  eks_node_role_name    = "eks-node-role-77"
  eks_cluster_id        = module.eks.eks_cluster_id
  oidc_issuer_url       = module.eks.eks_oidc_issuer_url
  oidc_provider_arn     = module.eks.eks_oidc_provider_arn
}

module "eks" {
  source             = "./modules/eks"
  eks_cluster_name   = var.cluster_name
  eks_role_arn       = module.iam.eks_cluster_role_arn
  kubernetes_version = "1.31"
  subnet_ids         = module.vpc.private_subnets_id
  security_group_ids = [module.vpc.eks_control_plane_sg_id]
  enable_logging     = true
  environment        = "dev"
  node_role_arn      = module.iam.eks_node_role_arn

}

output "eks_oidc_issuer" {
  value = module.eks.eks_oidc_issuer_url
}

output "eks_oidc_provider_arn" {
  value = module.eks.eks_oidc_provider_arn
}


module "autoscaler" {
  source                      = "./modules/autoscaler"
  eks_cluster_id              = module.eks.eks_cluster_id
  cluster_autoscaler_role_arn = module.iam.cluster_autoscaler_role_arn
  # cluster_autoscaler_oidc_arn     = module.iam.oidc_provider_arn
  depends_on   = [null_resource.update_kubeconfig]
  # eks_oidc_var = module.autoscaler.eks_oidc
  providers = {
    kubernetes = kubernetes
  }
}

resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ap-south-1 --name eks-cluster"
  }

  triggers = {
    always_run = timestamp()
  }
  depends_on = [module.eks]
}

module "ingress" {
  source       = "./modules/ingress"
  cluster_name = module.eks.eks_cluster_id # Reference EKS output
  
  #   providers = {
  #   kubernetes = kubernetes
  #   helm       = helm
  # }

  # depends_on = [module.eks]
}

module "alb" {
  source       = "./modules/alb"
  eks_cluster_name = var.cluster_name
  eks_cluster_id              = module.eks.eks_cluster_id
  vpc_id = module.vpc.vpc_id
  aws_region = var.aws_region
  alb_controller_role = module.iam.cluster_loadbalancer_role_arn
  

}

# resource "time_sleep" "wait_for_kubeconfig" {
#   depends_on = [null_resource.update_kubeconfig]

#   create_duration = "30s" # Wait for kubeconfig to update
# }





# ## to create nlb 
# module "nlb" {
#   source            = "./modules/nlb"
#   vpc_id           = module.vpc.vpc_id
#   subnets          = module.vpc.public_subnets_id
#   security_group_id = module.vpc.eks_nodes_sg_id
#   eks_worker_node_ips = module.eks.worker_node_ips
# }

# output "nlb_dns_name" {
#   value = module.nlb.nlb_dns_name
# }




