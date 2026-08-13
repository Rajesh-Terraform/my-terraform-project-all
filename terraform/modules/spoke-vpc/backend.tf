terraform {
  backend "s3" {
    bucket = "harish-gaddam-bucket123"
    key    = "networking/hub-spoke/terraform.tfstate"
    region = "ap-south-1"
  }
}