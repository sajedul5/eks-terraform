resource "aws_iam_role_policy_attachment" "eks_s3_full_permission" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = module.eks_node_group.node_group_iam_role_name
}
