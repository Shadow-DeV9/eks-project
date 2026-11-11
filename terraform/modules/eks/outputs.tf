output "cluster_endpoint" {
  value = aws_eks_cluster.example.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.example.certificate_authority[0].data
}

output "cluster_id" {
  value = aws_eks_cluster.example.id
}

output "oidc_issuer" {
  value = aws_eks_cluster.example.identity[0].oidc[0].issuer
}
