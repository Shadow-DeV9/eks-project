
variable "eks_cluster_role_arn" {
  description = "IAM role ARN used by the EKS cluster"
  type        = string
}

variable "eks_node_role_arn" {
  description = "IAM role ARN used by EKS worker nodes"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by the EKS cluster and worker nodes"
  type        = list(string)
}
