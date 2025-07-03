resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.cluster_name}-vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.cluster_name}-private-subnet-${count.index + 1}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
  
}
resource "aws_subnet" "public_subnet" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.cluster_name}-public-subnet-${count.index + 1}"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  } 
  
}
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.cluster_name}-igw"
  }
}
resource "aws_route_table" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.cluster_name}-public-route-table-${count.index + 1}"
  }
}
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  subnet_id = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_eip" "eip" {
  count = length(var.private_subnet_cidrs)

  tags = {
    Name = "${var.cluster_name}-nat-eip-${count.index + 1}"
  }
}
resource "aws_nat_gateway" "main" {
  count = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.eip[count.index].id
  subnet_id = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "${var.cluster_name}-nat-gateway-${count.index + 1}"
  }
}
resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  route {
  cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main[count.index].id
}


  tags = {
    Name = "${var.cluster_name}-private-route-table-${count.index + 1}"
  }
}
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  subnet_id = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}