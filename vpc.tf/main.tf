#VPC
resource "aws_vpc" "common_vpc" {
  cidr_block = var.VpcCidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.environment}_VPC"
  }
}

#VPC Internet Gateway
resource "aws_internet_gateway" "common_igw" {
  vpc_id = aws_vpc.common_vpc.id
  tags = {
    Name = "${var.environment}_IGW"
  }
}

#VPC Public Subnets
resource "aws_subnet" "publicsubnet1" {
  vpc_id     = aws_vpc.common_vpc.id
  cidr_block = var.publicsubnet1cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet1"
  }
}

resource "aws_subnet" "publicsubnet2" {
  vpc_id     = aws_vpc.common_vpc.id
  cidr_block = var.publicsubnet2cidr
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet2"
  }
}

#VPC Private Subnets
resource "aws_subnet" "privatesubnet1" {
  vpc_id     = aws_vpc.common_vpc.id
  cidr_block = var.privatesubnet1cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "PrivateSubnet1"
  }
}

resource "aws_subnet" "privatesubnet2" {
  vpc_id     = aws_vpc.common_vpc.id
  cidr_block = var.privatesubnet2cidr
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "PrivateSubnet2"
  }
}

#EIPs for NAT gateway
resource "aws_eip" "pvtsubnet1" {
  vpc = true
  depends_on = [
    aws_internet_gateway.common_igw
  ]
  tags = {
    "Name" = "PublicSubnet1aNAT_IP"
  }
}

resource "aws_eip" "pvtsubnet2" {
  vpc = true
  depends_on = [
    aws_internet_gateway.common_igw
  ]  
  tags = {
    "Name" = "PublicSubnet1bNAT_IP"
  }
}

#NAT Gateways
resource "aws_nat_gateway" "publicsubnet1nat" {
  allocation_id = aws_eip.pvtsubnet1.id
  subnet_id     = aws_subnet.publicsubnet1.id
  depends_on = [
    aws_internet_gateway.common_igw
  ]  
  tags = {
    Name = "NAT_GATEWAY_PublicSubnet1"
  }
}
resource "aws_nat_gateway" "publicsubnet2nat" {
  allocation_id = aws_eip.pvtsubnet2.id
  subnet_id     = aws_subnet.publicsubnet2.id
  depends_on = [
    aws_internet_gateway.common_igw
  ]  
  tags = {
    Name = "NAT_GATEWAY_PublicSubnet2"
  }
}

#Route Tables
resource "aws_route_table" "publicroutetable" {
  vpc_id = aws_vpc.common_vpc.id
  depends_on = [
    aws_internet_gateway.common_igw
  ]  
  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table" "privateroutetable1" {
  vpc_id = aws_vpc.common_vpc.id
  depends_on = [
    aws_nat_gateway.publicsubnet1nat
  ]  
  tags = {
    Name = "PrivateRouteTable1"
  }
}

resource "aws_route_table" "privateroutetable2" {
  vpc_id = aws_vpc.common_vpc.id
  depends_on = [
    aws_nat_gateway.publicsubnet2nat
  ]  
  tags = {
    Name = "PrivateRouteTable2"
  }
}

#Routes
resource "aws_route" "publicroute" {
  route_table_id            = aws_route_table.publicroutetable.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.common_igw.id
  depends_on                = [aws_route_table.publicroutetable, aws_internet_gateway.common_igw]
}

resource "aws_route" "privateroute1" {
  route_table_id = aws_route_table.privateroutetable1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.publicsubnet1nat.id
}

resource "aws_route" "privateroute2" {
  route_table_id = aws_route_table.privateroutetable2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.publicsubnet2nat.id
}

#Route Table Associations
resource "aws_route_table_association" "publicsubnet1" {
  subnet_id      = aws_subnet.publicsubnet1.id
  route_table_id = aws_route_table.publicroutetable.id
}

resource "aws_route_table_association" "publicsubnet2" {
  subnet_id      = aws_subnet.publicsubnet2.id
  route_table_id = aws_route_table.publicroutetable.id
}

resource "aws_route_table_association" "privatesubnet1" {
  subnet_id      = aws_subnet.privatesubnet1.id
  route_table_id = aws_route_table.privateroutetable1.id
}

resource "aws_route_table_association" "privatesubnet2" {
  subnet_id      = aws_subnet.privatesubnet2.id
  route_table_id = aws_route_table.privateroutetable2.id
}