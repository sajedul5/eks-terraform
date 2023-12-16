# eks-terraform
This is full setup AWS EKS with VPC, ELB and Route53 host-point
terraform apply -var-file=variables.tfvars

=> create variables.tfvars 
region = "Your region"
cluster_name = "Your cluster name"
node_group_name = "your-node-group"
cluster_version = "1.21"
node_group_desired_capacity = your node group capacity
node_group_max_capacity = your node group capacity
node_group_min_capacity = your node group capacity
instance_type = "your instance type"
subnet_cidr_a = "your subnet a"
subnet_cidr_b = "your subnet b"

