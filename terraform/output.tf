output "eks_cluster_name" {
  value = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cert_manager_role_arn" {
  value = module.irsa.cert_manager_role_arn
}

output "external_dns_role_arn" {
  value = module.irsa.external_dns_role_arn
}
