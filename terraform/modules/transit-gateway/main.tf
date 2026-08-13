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
# TRANSIT GATEWAY
# HUB ACCOUNT
# =========================================================

resource "aws_ec2_transit_gateway" "this" {
  description = "Hub Transit Gateway"

  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name = "hub-tgw"
  }
}

# =========================================================
# RAM SHARE
# HUB ACCOUNT
# =========================================================

resource "aws_ram_resource_share" "tgw" {
  name = "hub-tgw-share"

  allow_external_principals = true

  tags = {
    Name = "hub-tgw-share"
  }
}

# Share TGW
resource "aws_ram_resource_association" "tgw" {
  resource_arn = aws_ec2_transit_gateway.this.arn

  resource_share_arn = aws_ram_resource_share.tgw.arn
}

# Share with spoke account
resource "aws_ram_principal_association" "spoke" {
  principal = var.spoke_account_id

  resource_share_arn = aws_ram_resource_share.tgw.arn
}

# =========================================================
# HUB TGW ATTACHMENT
# =========================================================

resource "aws_ec2_transit_gateway_vpc_attachment" "hub" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  vpc_id = var.hub_vpc_id

  subnet_ids = var.hub_subnet_ids

  dns_support = "enable"

  tags = {
    Name = "hub-tgw-attachment"
  }
}

# =========================================================
# SPOKE TGW ATTACHMENT
# SPOKE ACCOUNT
# =========================================================

resource "aws_ec2_transit_gateway_vpc_attachment" "spoke" {
  provider = aws.spoke

  transit_gateway_id = aws_ec2_transit_gateway.this.id

  vpc_id = var.spoke_vpc_id

  subnet_ids = var.spoke_subnet_ids

  dns_support = "enable"

  tags = {
    Name = "spoke-tgw-attachment"
  }

  depends_on = [
    aws_ram_resource_association.tgw,
    aws_ram_principal_association.spoke
  ]
}

# =========================================================
# HUB TGW ROUTE TABLE
# =========================================================

resource "aws_ec2_transit_gateway_route_table" "hub" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = "hub-tgw-route-table"
  }
}

# =========================================================
# SPOKE TGW ROUTE TABLE
# =========================================================

resource "aws_ec2_transit_gateway_route_table" "spoke" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = "spoke-tgw-route-table"
  }
}

# =========================================================
# HUB ATTACHMENT ASSOCIATION
# =========================================================

resource "aws_ec2_transit_gateway_route_table_association" "hub" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.hub.id

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.hub.id
}

# =========================================================
# SPOKE ATTACHMENT ASSOCIATION
# =========================================================

resource "aws_ec2_transit_gateway_route_table_association" "spoke" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.spoke.id

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke.id
}

# =========================================================
# HUB → SPOKE
# =========================================================

resource "aws_ec2_transit_gateway_route" "hub_to_spoke" {
  destination_cidr_block = var.spoke_vpc_cidr

  transit_gateway_attachment_id =
    aws_ec2_transit_gateway_vpc_attachment.spoke.id

  transit_gateway_route_table_id =
    aws_ec2_transit_gateway_route_table.hub.id
}

# =========================================================
# SPOKE → HUB
# =========================================================

resource "aws_ec2_transit_gateway_route" "spoke_to_hub" {
  destination_cidr_block = var.hub_vpc_cidr

  transit_gateway_attachment_id =
    aws_ec2_transit_gateway_vpc_attachment.hub.id

  transit_gateway_route_table_id =
    aws_ec2_transit_gateway_route_table.spoke.id  
}  