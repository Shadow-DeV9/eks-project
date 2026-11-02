data "aws_route53_zone" "public" {
  name         = "${trimsuffix(var.domain_name, ".")}."
  private_zone = false
}

locals {
  oidc_issuer_host = trimprefix(module.eks.cluster_oidc_issuer_url, "https://")
  route53_zone_arn = "arn:aws:route53:::hostedzone/${data.aws_route53_zone.public.zone_id}"
}

resource "aws_iam_openid_connect_provider" "eks" {
  url            = module.eks.cluster_oidc_issuer_url
  client_id_list = ["sts.amazonaws.com"]
}

resource "aws_iam_policy" "route53_dns" {
  name        = "eks-route53-dns-${module.eks.cluster_id}"
  description = "Allow EKS DNS workloads to manage records only in the application hosted zone"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResource",
        ]
        Resource = local.route53_zone_arn
      },
      {
        Effect = "Allow"
        Action = [
          "route53:GetChange",
          "route53:ListHostedZones",
          "route53:ListHostedZonesByName",
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "cert_manager" {
  name = "cert-manager-${module.eks.cluster_id}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Condition = {
          StringEquals = {
            "${local.oidc_issuer_host}:aud" = "sts.amazonaws.com"
            "${local.oidc_issuer_host}:sub" = "system:serviceaccount:cert-manager:cert-manager"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cert_manager_route53" {
  role       = aws_iam_role.cert_manager.name
  policy_arn = aws_iam_policy.route53_dns.arn
}

resource "aws_iam_role" "external_dns" {
  name = "external-dns-${module.eks.cluster_id}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Condition = {
          StringEquals = {
            "${local.oidc_issuer_host}:aud" = "sts.amazonaws.com"
            "${local.oidc_issuer_host}:sub" = "system:serviceaccount:external-dns:external-dns-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "external_dns_route53" {
  role       = aws_iam_role.external_dns.name
  policy_arn = aws_iam_policy.route53_dns.arn
}
