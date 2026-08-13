terraform {
  backend "s3" {
    bucket = "harish-gaddam-bucket123"
    key    = "spoke-vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}  