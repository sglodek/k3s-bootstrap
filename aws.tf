provider "aws" {
  region  = "us-west-2"
  profile = "systest"

  default_tags {
    tags = {
      Name  = "k3s-sglodek"
      owner = "sglodek"
    }
  }
}