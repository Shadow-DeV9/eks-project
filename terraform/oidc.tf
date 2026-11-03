resource "aws_iam_openid_connect_provider" "eks" {
  url = module.eks.oidc_issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  tags = {
    Name        = "eks-oidc-provider"
    Environment = "Dev"
  }
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}
