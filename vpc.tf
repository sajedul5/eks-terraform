resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
  # Other VPC configurations

  tags = {
    Name = "eks-vpc"
  }
}

resource "aws_subnet" "eks_subnet_a" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.subnet_cidr_a
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-subnet-a"
  }
}

resource "aws_subnet" "eks_subnet_b" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.subnet_cidr_b
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-subnet-b"
  }
}
