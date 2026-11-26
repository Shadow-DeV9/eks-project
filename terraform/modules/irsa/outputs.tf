output "cert_manager_role_arn" {
  value = module.cert_manager_irsa_role.iam_role_arn
}

output "external_dns_role_arn" {
  value = module.external_dns_irsa_role.iam_role_arn
}


output "ebs_csi_driver_role_arn" {
  description = "IAM role ARN for the EBS CSI driver"
  value       = module.ebs_csi_driver_irsa_role.iam_role_arn
}
