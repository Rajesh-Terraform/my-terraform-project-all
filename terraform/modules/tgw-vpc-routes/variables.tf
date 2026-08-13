variable "hub_private_route_table_ids" {
  type = list(string)
}

variable "spoke_private_route_table_ids" {
  type = list(string)
}

variable "transit_gateway_id" {
  type = string
}

variable "hub_vpc_cidr" {
  type = string
}

variable "spoke_vpc_cidr" {
  type = string
}  