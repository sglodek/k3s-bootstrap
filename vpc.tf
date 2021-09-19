resource "aws_vpc" "k3s" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "k3s" {
  vpc_id = aws_vpc.k3s.id
}

resource "aws_default_route_table" "k3s" {
  default_route_table_id = aws_vpc.k3s.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k3s.id
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.k3s.id
  cidr_block = "10.0.1.0/24"

  map_public_ip_on_launch = true
}