
output "cluster_id" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.example.name
}

output "cluster_endpoint" {
  description = "EKS Kubernetes API endpoint"
  value       = aws_eks_cluster.example.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded EKS cluster certificate authority data"
  value       = aws_eks_cluster.example.certificate_authority[0].data
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL used for IAM Roles for Service Accounts"
  value       = aws_eks_cluster.example.identity[0].oidc[0].issuer
}
