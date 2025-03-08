variable "vpc_id" {}
variable "subnets" { type = list(string) }
variable "security_group_id" {}
variable "eks_worker_node_ips" { type = list(string) }
