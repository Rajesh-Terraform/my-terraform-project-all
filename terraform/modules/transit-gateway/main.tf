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


# ============================================================
# 1. TRANSIT GATEWAY
# ============================================================

resource "aws_ec2_transit_gateway" "this" {
  description = "Hub Transit Gateway"

  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name = "hub-tgw"
  }
}


# ============================================================
# 2. HUB VPC ATTACHMENT
# ============================================================

resource "aws_ec2_transit_gateway_vpc_attachment" "hub" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.hub_vpc_id

  subnet_ids = var.hub_subnet_ids

  tags = {
    Name = "hub-tgw-attachment"
  }
}


# ============================================================
# 3. SPOKE VPC ATTACHMENT
# ============================================================

resource "aws_ec2_transit_gateway_vpc_attachment" "spoke" {
  provider = aws.spoke

  transit_gateway_id = var.transit_gateway_id
  vpc_id             = var.spoke_vpc_id

  subnet_ids = var.spoke_subnet_ids

  tags = {
    Name = "spoke-tgw-attachment"
  }
}


# ============================================================
# 4. HUB TGW ROUTE TABLE
# ============================================================

resource "aws_ec2_transit_gateway_route_table" "hub" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = "hub-tgw-route-table"
  }
}


# ============================================================
# 5. SPOKE TGW ROUTE TABLE
# ============================================================

resource "aws_ec2_transit_gateway_route_table" "spoke" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = "spoke-tgw-route-table"
  }
}


# ============================================================
# 6. HUB -> SPOKE ROUTE
# ============================================================

resource "aws_ec2_transit_gateway_route" "hub_to_spoke" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.hub.id
  destination_cidr_block         = var.spoke_vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke.id
}


# ============================================================
# 7. SPOKE -> HUB ROUTE
# ============================================================

resource "aws_ec2_transit_gateway_route" "spoke_to_hub" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke.id
  destination_cidr_block         = var.hub_vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.hub.id
}