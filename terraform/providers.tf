terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# =========================================================
# HUB ACCOUNT
# =========================================================

provider "aws" {
  alias  = "hub"
  region = var.aws_region
}

# =========================================================
# SPOKE ACCOUNT
# =========================================================

provider "aws" {
  alias  = "spoke"
  region = var.aws_region

  assume_role {
    role_arn = var.spoke_role_arn
  }
}  