data "aws_availability_zones" "available" {
  state = "available"
}

# =========================================================
# HUB VPC
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
# INTERNET GATEWAY
# =========================================================

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-igw"
  }
}

# =========================================================
# PUBLIC SUBNET 1
# =========================================================

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-1"
  }
}

# =========================================================
# PUBLIC SUBNET 2
# =========================================================

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-2"
  }
}

# =========================================================
# PRIVATE SUBNET 1
# =========================================================

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.10.0/24"
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
  cidr_block        = "10.0.11.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.name}-private-2"
  }
}

# =========================================================
# PUBLIC ROUTE TABLE
# =========================================================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-public-rt"
  }
}

# Internet route
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# =========================================================
# PUBLIC ROUTE TABLE ASSOCIATIONS
# =========================================================

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# =========================================================
# NAT EIP 1
# =========================================================

resource "aws_eip" "nat_1" {
  domain = "vpc"

  tags = {
    Name = "${var.name}-nat-eip-1"
  }
}

# =========================================================
# NAT EIP 2
# =========================================================

resource "aws_eip" "nat_2" {
  domain = "vpc"

  tags = {
    Name = "${var.name}-nat-eip-2"
  }
}

# =========================================================
# NAT GATEWAY 1
# =========================================================

resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_1.id
  subnet_id     = aws_subnet.public_1.id

  depends_on = [
    aws_internet_gateway.this
  ]

  tags = {
    Name = "${var.name}-nat-1"
  }
}

# =========================================================
# NAT GATEWAY 2
# =========================================================

resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.nat_2.id
  subnet_id     = aws_subnet.public_2.id

  depends_on = [
    aws_internet_gateway.this
  ]

  tags = {
    Name = "${var.name}-nat-2"
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

# Private subnet 1 → NAT 1
resource "aws_route" "private_1_nat" {
  route_table_id         = aws_route_table.private_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_1.id
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

# Private subnet 2 → NAT 2
resource "aws_route" "private_2_nat" {
  route_table_id         = aws_route_table.private_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_2.id
}

# =========================================================
# PRIVATE ROUTE ASSOCIATIONS
# =========================================================

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_2.id
} 