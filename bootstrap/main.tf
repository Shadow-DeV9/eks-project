resource "aws_s3_bucket" "project_s3_bucket" {
  bucket = "bankai-kannonbiraki-benihime-attarame12"

  tags = {
    Name        = "terraform-state"
    Environment = "Dev"
  }
}
