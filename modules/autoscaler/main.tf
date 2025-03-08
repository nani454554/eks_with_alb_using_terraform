resource "kubernetes_service_account" "cluster_autoscaler" {
  metadata {
    name      = "cluster-autoscaler-sa"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = var.cluster_autoscaler_role_arn
      # "eks.amazonaws.com/oidc-arn" = var.cluster_autoscaler_oidc_arn
    }
  }
  # depends_on = [ var.eks_cluster_id ]
}


resource "kubernetes_cluster_role" "cluster_autoscaler" {
  metadata {
    name = "cluster-autoscaler-role"
  }

  rule {
    api_groups = [""]
    resources  = ["events", "endpoints"]
    verbs      = ["create", "patch"]
  }

   rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["get", "watch", "list", "update", "create"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services"]
    verbs      = ["get", "list", "watch"]
  }

    rule {
    api_groups = [""]
    resources  = ["nodes"]  # ✅ Added this to allow autoscaler to access nodes
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumeclaims"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes/status"]
    verbs      = ["patch"]
  }

  rule {
    api_groups = ["autoscaling.k8s.io"]
    resources  = ["verticalpodautoscalers"]
    verbs      = ["get", "list"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["csinodes"]
    verbs      = ["get", "list", "watch"]
  }

  # depends_on = [ var.eks_cluster_id ]
}

resource "kubernetes_cluster_role_binding" "cluster_autoscaler" {
  metadata {
    name = "cluster-autoscaler-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.cluster_autoscaler.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cluster_autoscaler.metadata[0].name
    namespace = "kube-system"
  }
  # depends_on = [ var.eks_cluster_id ]
}



resource "kubernetes_deployment" "cluster_autoscaler" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
    labels = {
      app = "cluster-autoscaler"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "cluster-autoscaler"
      }
    }

    template {
      metadata {
        labels = {
          app = "cluster-autoscaler"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.cluster_autoscaler.metadata[0].name

        container {
          name  = "cluster-autoscaler"
          image = "registry.k8s.io/autoscaling/cluster-autoscaler:v1.27.0"

          command = [
            "./cluster-autoscaler",
            "--v=4",
            "--stderrthreshold=info",
            "--cloud-provider=aws",
            "--skip-nodes-with-local-storage=false",
            "--expander=least-waste",
            "--balance-similar-node-groups",
            "--nodes=1:4:nodegroup1",
            "--nodes=1:4:nodegroup2"
          ]

          resources {
            limits = {
              cpu    = "100m"
              memory = "300Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "300Mi"
            }
          }
        }
      }
    }
  }

   depends_on = [ 
    kubernetes_service_account.cluster_autoscaler,
    kubernetes_cluster_role_binding.cluster_autoscaler
  ]
}





#  data "tls_certificate" "eks_oidc" {
#   url = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
# }

# resource "aws_iam_openid_connect_provider" "eks" {
#   url             = "https://oidc.eks.ap-south-1.amazonaws.com/id/45AFF6AA88AF3E7F20350010C93A0792"
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]
# }

# output "eks_oidc" {
#   value = aws_iam_openid_connect_provider.eks.arn
  
# }
# variable "eks_oidc_var" {
#   description = "value"
#   type = list(string)	
  
# }


# resource "aws_iam_role" "autoscaler_role" {
#   name = "eks-autoscaler-role"

#   assume_role_policy = jsonencode({
#     Version   = "2012-10-17"
#     Statement = [
#       {
#         Effect    = "Allow"
#         Principal = {
#           Federated = var.eks_oidc_var
#         }
#         Action = "sts:AssumeRoleWithWebIdentity"
#         Condition = {
#           StringEquals = {
#             "oidc.eks.ap-south-1.amazonaws.com/id/45AFF6AA88AF3E7F20350010C93A0792:sub" = "system:serviceaccount:kube-system:cluster-autoscaler"
#           }
#         }
#       }
#     ]
#   })
#   # Add further role policies as needed
# }

# resource "aws_iam_policy" "autoscaler_policy" {
#   name        = "eks-autoscaler-policy"
#   description = "Policy for the EKS Autoscaler"
#   policy      = jsonencode({
#     Version   = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = [
#           "autoscaling:DescribeAutoScalingGroups",
#           "autoscaling:DescribeAutoScalingInstances",
#           "autoscaling:DescribeLaunchConfigurations",
#           "autoscaling:DescribeTags",
#           "autoscaling:SetDesiredCapacity",
#           "autoscaling:TerminateInstanceInAutoScalingGroup"
#         ]
#         Resource = "*"
#       },
#       {
#         Effect   = "Allow"
#         Action   = [
#           "ec2:DescribeLaunchTemplateVersions"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "autoscaler_policy_attachment" {
#   role       = aws_iam_role.autoscaler_role.name
#   policy_arn = aws_iam_policy.autoscaler_policy.arn
# }