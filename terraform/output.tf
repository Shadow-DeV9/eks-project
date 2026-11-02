output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "EKS Kubernetes API endpoint"
  value       = module.eks.cluster_endpoint
}

output "application_domain" {
  description = "Domain managed for the application ingress"
  value       = var.domain_name
}

output "route53_hosted_zone_id" {
  description = "Public Route53 hosted zone managing the application domain"
  value       = data.aws_route53_zone.public.zone_id
}