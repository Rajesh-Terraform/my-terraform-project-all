terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

      configuration_aliases = [
        aws.spoke
      ]
    }
  }
}


# =========================================================
# HUB VPC ROUTE
# HUB ACCOUNT
# =========================================================

resource "aws_route" "hub_to_spoke" {

  for_each = toset(var.hub_private_route_table_ids)

  route_table_id = each.value

  destination_cidr_block = var.spoke_vpc_cidr

  transit_gateway_id = var.transit_gateway_id
}


# =========================================================
# SPOKE VPC ROUTE
# SPOKE ACCOUNT
# =========================================================

resource "aws_route" "spoke_to_hub" {

  provider = aws.spoke

  for_each = toset(var.spoke_private_route_table_ids)

  route_table_id = each.value

  destination_cidr_block = var.hub_vpc_cidr

  transit_gateway_id = var.transit_gateway_id
}  