module "eks_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/node_group"

  cluster_name      = module.eks.cluster_id
  node_group_name   = var.node_group_name
  subnets           = [aws_subnet.eks_subnet_a.id, aws_subnet.eks_subnet_b.id]
  desired_capacity  = var.node_group_desired_capacity
  max_capacity      = var.node_group_max_capacity
  min_capacity      = var.node_group_min_capacity

  instance_type = var.instance_type
}
