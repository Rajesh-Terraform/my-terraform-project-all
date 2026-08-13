# =========================================================
# PHASE 1
# HUB VPC
# =========================================================

module "hub_vpc" {
  source = "./modules/hub-vpc"

  providers = {
    aws = aws.hub
  }

  name     = "hub-vpc"
  vpc_cidr = "10.0.0.0/16"
}


# =========================================================
# PHASE 2
# SPOKE VPC
# =========================================================

module "spoke_vpc" {
  source = "./modules/spoke-vpc"

  providers = {
    aws = aws.spoke
  }

  name     = "spoke-vpc"
  vpc_cidr = "10.1.0.0/16"
}


# =========================================================
# PHASE 3
# TRANSIT GATEWAY
# =========================================================

module "transit_gateway" {
  source = "./modules/transit-gateway"

  providers = {
    aws       = aws.hub
    aws.spoke = aws.spoke
  }

  # HUB VPC
  hub_vpc_id = module.hub_vpc.vpc_id

  hub_subnet_ids = module.hub_vpc.private_subnet_ids

  hub_vpc_cidr = "10.0.0.0/16"

  # SPOKE VPC
  spoke_vpc_id = module.spoke_vpc.vpc_id

  spoke_subnet_ids = module.spoke_vpc.private_subnet_ids

  spoke_vpc_cidr = "10.1.0.0/16"

  # SPOKE AWS ACCOUNT
  spoke_account_id = "434097521299"
}


# =========================================================
# PHASE 3
# VPC ROUTES → TRANSIT GATEWAY
# =========================================================

module "tgw_vpc_routes" {
  source = "./modules/tgw-vpc-routes"

  providers = {
    aws       = aws.hub
    aws.spoke = aws.spoke
  }

  # HUB ROUTE TABLES
  hub_private_route_table_ids = module.hub_vpc.private_route_table_ids

  # SPOKE ROUTE TABLES
  spoke_private_route_table_ids = module.spoke_vpc.private_route_table_ids

  # TGW
  transit_gateway_id = module.transit_gateway.transit_gateway_id

  # CIDRs
  hub_vpc_cidr   = "10.0.0.0/16"
  spoke_vpc_cidr = "10.1.0.0/16"

  depends_on = [
    module.transit_gateway
  ]
}  