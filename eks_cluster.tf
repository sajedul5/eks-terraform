module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  subnets         = [aws_subnet.eks_subnet_a.id, aws_subnet.eks_subnet_b.id]
  vpc_id          = aws_vpc.eks_vpc.id
  cluster_version = var.cluster_version
}
