# resource "kubernetes_namespace" "logging" {
#   metadata {
#     name = "logging"
#   }
# }

# resource "kubernetes_namespace" "elastic_system" {
#   metadata {
#     name = "elastic-system"
#   }
# }



# resource "kubernetes_service_account" "fluentbit" {
#   metadata {
#     name      = "fluentbit-sa"
#     namespace = "logging"
#     annotations = {
#       "eks.amazonaws.com/role-arn" = aws_iam_role.fluentbit_role.arn
#     }
#   }
# }

# resource "kubernetes_service_account" "eck_operator" {
#   metadata {
#     name      = "eck-operator-sa"
#     namespace = "elastic-system"
#     annotations = {
#       "eks.amazonaws.com/role-arn" = aws_iam_role.eck_role.arn
#     }
#   }
# }
