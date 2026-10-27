
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
