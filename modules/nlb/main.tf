resource "aws_lb" "nlb" {
  name               = "eks-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnets
  security_groups    = [var.security_group_id]
}

resource "aws_lb_target_group" "nlb_tg" {
  name        = "eks-nlb-tg"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    protocol            = "TCP"
    port                = "80"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "eks_nodes" {
  count            = length(var.eks_worker_node_ips)
  target_group_arn = aws_lb_target_group.nlb_tg.arn
  target_id        = var.eks_worker_node_ips[count.index]
  port             = 80
}
