
resource "aws_eks_cluster" "eks-cluster" {
  name     = "eks-cluster"
  role_arn = var.eks_cluster_role_arn
  version  = "1.36"

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [aws_cloudwatch_log_group.eks_cluster_logs]

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }
}

resource "aws_cloudwatch_log_group" "eks_cluster_logs" {
  name              = "/aws/eks/eks-cluster/cluster"
  retention_in_days = 7
}

resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "example"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = ["t3.small"]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.eks-cluster.name
  addon_name   = "vpc-cni"
}
