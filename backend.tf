terraform {
  backend "s3" {
    key    = "terraform.tfstate"
    bucket = "terraform.trainingdevops.cloud"
    region = "us-east-2"
  }
}
