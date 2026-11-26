resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name = module.eks.cluster_id
  addon_name   = "aws-ebs-csi-driver"

  service_account_role_arn = module.irsa.ebs_csi_driver_role_arn
}
