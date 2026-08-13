output "hub_vpc_id" {
  value = module.hub_vpc.vpc_id
}

output "hub_private_subnet_ids" {
  value = module.hub_vpc.private_subnet_ids
}

output "spoke_vpc_id" {
  value = module.spoke_vpc.vpc_id
}

output "spoke_private_subnet_ids" {
  value = module.spoke_vpc.private_subnet_ids
}

output "transit_gateway_id" {
  value = module.transit_gateway.transit_gateway_id
}

output "hub_tgw_route_table_id" {
  value = module.transit_gateway.hub_route_table_id
}

output "spoke_tgw_route_table_id" {
  value = module.transit_gateway.spoke_route_table_id
}

output "hub_tgw_attachment_id" {
  value = module.transit_gateway.hub_attachment_id
}

output "spoke_tgw_attachment_id" {
  value = module.transit_gateway.spoke_attachment_id
} 