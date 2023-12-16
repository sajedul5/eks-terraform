provider "aws" {
  region = "us-west-2" # Change this to your desired region
}

# Create VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks-vpc"
  }
}

# Create Subnets
resource "aws_subnet" "eks_subnet_a" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-subnet-a"
  }
}

resource "aws_subnet" "eks_subnet_b" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-subnet-b"
  }
}

# Create EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-eks-cluster"
  subnets         = [aws_subnet.eks_subnet_a.id, aws_subnet.eks_subnet_b.id]
  vpc_id          = aws_vpc.eks_vpc.id
  cluster_version = "1.21"
}

# Add Node Group to EKS Cluster
module "eks_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/node_group"

  cluster_name = module.eks.cluster_id
  node_group_name = "my-node-group"

  subnets             = [aws_subnet.eks_subnet_a.id, aws_subnet.eks_subnet_b.id]
  desired_capacity   = 2
  max_capacity       = 3
  min_capacity       = 1

  instance_type = "t2.micro" # Change this to the desired instance type
}

# Grant S3 Full Permission to EKS Nodes
resource "aws_iam_role_policy_attachment" "eks_s3_full_permission" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = module.eks_node_group.node_group_iam_role_name
}

# Create Load Balancer
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

# Output EKS Cluster Config
output "eks_cluster_config" {
  value = module.eks
}

# Output EKS Node Group Config
output "eks_node_group_config" {
  value = module.eks_node_group
}

# Output Load Balancer DNS Name
output "eks_lb_dns_name" {
  value = aws_lb.eks_lb.dns_name
}
