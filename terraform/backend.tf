terraform {
  backend "s3" {
    bucket = "dhoni-demo-terraform-bucket-123456"
    key    = "networking/hub-spoke/terraform.tfstate"
    region = "ap-south-1"
  }
}


terraform {
  backend "s3" {
    bucket = "harish-gaddam-bucket123"
    key    = "networking/hub-spoke/terraform.tfstate"
    region = "ap-south-1"
  }
}




 