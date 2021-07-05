# Create VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name     = "main-vpc-${terraform.workspace}"
    Location = "Bangalore"

  }

}


# Create a Pulic Subnets equal to number of az's

resource "aws_subnet" "public" {
  count  = length(local.az_names)
  vpc_id = aws_vpc.main.id
  # cidrsubnet calculates a subnet address within given IP network address prefix.
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = local.az_names[count.index]

  tags = {
    Name = "public-${count.index + 1}"
  }

}

# To make it public we need to create Internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "myapp-gw"
  }
}

# Create route table for Public subnet

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Subnet Association to public route table

resource "aws_route_table_association" "public" {
  # Below count block Will list of public subnet ID's
  count          = length(local.pub_sub_ids)
  subnet_id      = local.pub_sub_ids[count.index]
  route_table_id = aws_route_table.public.id
}

# Create a Private Subnets equal to number of az's

resource "aws_subnet" "private" {
  count  = length(local.az_names)
  vpc_id = aws_vpc.main.id
  # cidrsubnet calculates a subnet address within given IP network address prefix.
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + length(local.pub_sub_ids))
  availability_zone = local.az_names[count.index]

  tags = {
    Name = "private-${count.index + 1}"
  }

}

# Create route table for Private subnet

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw.id
  }

  tags = {
    Name = "private-rt"
  }
}

# Subnet Association to Private route table

resource "aws_route_table_association" "private" {
  # Below count block Will list of Private subnet ID's
  count          = length(local.pri_sub_ids)
  subnet_id      = local.pri_sub_ids[count.index]
  route_table_id = aws_route_table.private.id
}

# Create Elastic IP for NAT Gateway

resource "aws_eip" "nat" {
  vpc = true
}

# Create NAT Gateway

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  # Below Block defines, NAT gateway should be in Public but used by Private
  subnet_id = local.pub_sub_ids[0]

}