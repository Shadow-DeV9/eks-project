
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

provider "helm" {
  kubernetes = {
    host = data.terraform_remote_state.infrastructure.outputs.eks_cluster_endpoint

    cluster_ca_certificate = base64decode(
      data.terraform_remote_state.infrastructure.outputs.eks_cluster_certificate_authority_data
    )

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"

      args = [
        "eks",
        "get-token",
        "--cluster-name",
        data.terraform_remote_state.infrastructure.outputs.eks_cluster_name
      ]
    }
  }
}
