output "cert_manager_role_arn" {
  value = module.cert_manager_irsa_role.iam_role_arn
}
