variable "hub_vpc_id" {
  type = string
}

variable "hub_subnet_ids" {
  type = list(string)
}

variable "spoke_vpc_id" {
  type = string
}

variable "spoke_subnet_ids" {
  type = list(string)
}

variable "spoke_account_id" {
  type = string
}

variable "hub_vpc_cidr" {
  type = string
}

variable "spoke_vpc_cidr" {
  type = string
}  