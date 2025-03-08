variable "eks_cluster_name" {
    description = "cluster name"
    type        = string
}

variable "alb_controller_role"{
    description = "IAM role for ALB controller"
    type        = string

}

variable "vpc_id" {
    description = "vpc id"
    type        = string
  }

variable "aws_region" {
    description = "AWS region"
    type        = string  
}
variable "eks_cluster_id" {
  
  description = "The EKS cluster ID"
  type        = string
}
