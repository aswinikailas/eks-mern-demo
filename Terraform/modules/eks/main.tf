resource "aws_iam_role" "clusterrole" {
  name = "${var.cluster_name}_cluster_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "clusterpolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.clusterrole.name
  
}

resource "aws_eks_cluster" "main" {
  name = var.cluster_name
  version = var.cluster_version
  role_arn = aws_iam_role.clusterrole.arn
  vpc_config {
    subnet_ids = var.subnet_ids
  }
  depends_on = [ 
    aws_iam_role_policy_attachment.clusterpolicy
   ]
}
resource "aws_iam_role" "nodegrouprole" {
  name = "${var.cluster_name}_node_role"

  assume_role_policy = jsonencode({
  Version = "2012-10-17"
  Statement = [{
    Action = "sts:AssumeRole"
    Effect = "Allow"
    Principal = {
      Service = "ec2.amazonaws.com"
    }
  }]
})

}
resource "aws_iam_role_policy_attachment" "nodegroup_policy" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",
  ])
  policy_arn = each.value
  role       = aws_iam_role.nodegrouprole.name
}
resource "aws_eks_node_group" "main" {
  for_each = var.node_groups 
  
  cluster_name = aws_eks_cluster.main.name
  node_group_name = each.key
  node_role_arn = aws_iam_role.nodegrouprole.arn
  subnet_ids = var.subnet_ids 
  instance_types = each.value.instance_types
  scaling_config {
    desired_size = each.value.scaling_configs.desired_size
    max_size     = each.value.scaling_configs.max_size
    min_size     = each.value.scaling_configs.min_size
}
  depends_on = [
    aws_iam_role_policy_attachment.nodegroup_policy
  ]
} 