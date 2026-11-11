
terraform {
  backend "s3" {
    bucket       = "bankai-kannonbiraki-benihime-attarame12"
    key          = "terraform-addons.tfstate"
    region       = "eu-north-1"
    use_lockfile = true
  }
}

data "terraform_remote_state" "infrastructure" {
  backend = "s3"

  config = {
    bucket = "bankai-kannonbiraki-benihime-attarame12"
    key    = "terraform.tfstate"
    region = "eu-north-1"
  }
}
