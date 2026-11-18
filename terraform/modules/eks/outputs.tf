output "cluster_endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.eks-cluster.certificate_authority[0].data
}

output "cluster_id" {
  value = aws_eks_cluster.eks-cluster.id
}

output "oidc_issuer" {
  value = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}
