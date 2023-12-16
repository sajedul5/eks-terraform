resource "aws_lb" "eks_lb" {
  name               = "eks-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_vpc.eks_vpc.default_security_group_ids[0]]

  enable_deletion_protection = false

  enable_cross_zone_load_balancing = true
  enable_http2                     = true

  subnets = [aws_subnet.eks_subnet_a.id, aws_subnet.eks_subnet_b.id]

  enable_deletion_protection = false

  tags = {
    Name = "eks-lb"
  }
}
