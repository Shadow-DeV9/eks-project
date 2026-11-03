variable "oidc_provider_arn" {
  description = "The ARN of the OIDC provider for the EKS cluster"
  type        = string
}

variable "route53_hosted_zone_arn" {
  description = "The ARN of the Route 53 hosted zone for the EKS cluster"
  type        = string
}
