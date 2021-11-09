# Fetching dynamic ddata
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "vpc"
    env  = var.env
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name        = "public-subnet"
    Environment = var.env
  }
}

# Ref: https://stackoverflow.com/questions/61343796/terraform-get-list-index-on-for-each
# for_each won't give index

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = "false"
  tags = {
    Name        = "private-subnet"
    Environment = var.env
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "igw"
    Environment = var.env
  }
}

resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name        = "public-route"
    Environment = var.env
  }
}

resource "aws_route_table_association" "route-public-subnet-1" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public-route.id
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name        = "nat"
    Environment = var.env
  }
}

resource "aws_route_table" "private-route" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name        = "private-route"
    Environment = var.env
  }
}

resource "aws_route_table_association" "route-private-subnet-1" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private-route.id
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "everything-allowed"
    Environment = var.env
  }
}
