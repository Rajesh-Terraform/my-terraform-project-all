output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.this.id
}

output "hub_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.hub.id
}

output "spoke_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.spoke.id
}

output "hub_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.hub.id
}

output "spoke_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.spoke.id
}  