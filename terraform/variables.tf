variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "spoke_role_arn" {
  description = "IAM role ARN in spoke account"
  type        = string
  default     = null
}