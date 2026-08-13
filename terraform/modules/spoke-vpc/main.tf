data "aws_availability_zones" "available" {
  state = "available"
}

# =========================================================
# SPOKE VPC
# =========================================================

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.name
  }
}

# =========================================================
# PRIVATE SUBNET 1
# =========================================================

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.1.0.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.name}-private-1"
  }
}

# =========================================================
# PRIVATE SUBNET 2
# =========================================================

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.name}-private-2"
  }
}

# =========================================================
# PRIVATE ROUTE TABLE 1
# =========================================================

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-private-rt-1"
  }
}

# =========================================================
# PRIVATE ROUTE TABLE 2
# =========================================================

resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-private-rt-2"
  }
}

# =========================================================
# ASSOCIATIONS
# =========================================================

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_2.id
}  