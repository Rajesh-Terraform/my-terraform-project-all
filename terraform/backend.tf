terraform {
  backend "s3" {
    bucket = "dhoni-demo-terraform-bucket-123456"
    key    = "networking/hub-spoke/terraform.tfstate"
    region = "ap-south-1"
  }
}