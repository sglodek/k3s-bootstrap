provider "aws" {
  region  = "us-west-2"
  profile = var.aws_profile

  default_tags {
    tags = {
      Name  = "k3s-sglodek"
      owner = "sglodek"
    }
  }
}