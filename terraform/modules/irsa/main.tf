module "cert_manager_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                     = "cert-manager"
  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = ["arn:aws:route53:::hostedzone/YOUR_HOSTED_ZONE_ID"]

  oidc_providers = {
    eks = {
      provider_arn              = var.oidc_provider_arn
      namespace_service_account = ["cert-manager:cert-manager"]
    }
  }

}

module "external_dns_irsa_role" {
  source  = "terraform-aws-modules/iam-oidc/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  attach_external_dns_policy   = true
  external_dns_hosted_zone_arn = "arn:aws:route53:::hostedzone/YOUR_HOSTED_ZONE_ID"
  role_name                    = "external-dns-irsa-role"

  oidc_roviders = {
    eks = {
      oidc_provider_arn         = var.oidc_provider_arn
      namespace_service_account = ["external-dns:external-dns"]
    }
  }
}


module "cert_manager_irsa_role" {
  source = "terraform-aws-modules/iam-oidc/aws//modules/iam-role-for-service-accounts-eks"

  oidc_provider_arn = var.oidc_provider_arn
  namespace         = "cert-manager"
  service_account   = "cert-manager"
  role_name         = "cert-manager-irsa-role"

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKS_CertManagerPolicy"
  ]
}
