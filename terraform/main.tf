
module "eks" {
  source = "./modules/eks"

  eks_cluster_role_arn = module.iam.eks_cluster_role
  eks_node_role_arn    = module.iam.eks_node_group_role
  private_subnet_ids   = module.vpc.private_subnet_ids

  depends_on = [module.iam]
}

module "vpc" {
  source = "./modules/vpc"
}

module "iam" {
  source = "./modules/iam"
}

module "ecr" {
  source = "./modules/ecr"
}

module "sgs" {
  source = "./modules/sgs"

  vpc_id = module.vpc.vpc_id
}

module "irsa" {
  source = "./modules/irsa"

  oidc_provider_arn       = aws_iam_openid_connect_provider.eks.arn
  route53_hosted_zone_arn = "arn:aws:route53:::hostedzone/Z0950142301ZY0XM88IDB"
}
