terraform {
  backend "s3" {
    bucket = "spoke-s3-bucket-13"
    key    = "networking/hub-spoke/terraform.tfstate"
    region = "ap-south-1"
  }
}

  


