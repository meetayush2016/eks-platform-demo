# terraform/modules/vpc/main.tf

# ─── VPC ────────────────────────────────────────────────────
resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.env}-vpc"
    Env  = var.env
  }
}

# ─── PUBLIC SUBNETS ─────────────────────────────────────────
resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.env}-public-subnet-${count.index + 1}"
    "kubernetes.io/role/elb" = "1"
  }
}

# ─── PRIVATE SUBNETS ────────────────────────────────────────
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr, 8, count.index + 10)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name                              = "${var.env}-private-subnet-${count.index + 1}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# ─── INTERNET GATEWAY ───────────────────────────────────────
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}

# ─── ELASTIC IP FOR NAT ─────────────────────────────────────
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.env}-nat-eip"
  }
}

# ─── NAT GATEWAY ────────────────────────────────────────────
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.env}-nat-gw"
  }

  depends_on = [aws_internet_gateway.main]
}

# ─── PUBLIC ROUTE TABLE ─────────────────────────────────────
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.env}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ─── PRIVATE ROUTE TABLE ────────────────────────────────────
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.env}-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# ─── DATA SOURCE ────────────────────────────────────────────
data "aws_availability_zones" "available" {
  state = "available"
}