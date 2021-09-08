resource "aws_route_table" "public" {
  vpc_id = aws_vpc.infra-workshop-tajiri.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_gw.id
  }
}

resource "aws_internet_gateway" "vpc_gw" {
  vpc_id = aws_vpc.infra-workshop-tajiri.id
}

resource "aws_eip" "public" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.public.id
  subnet_id     = aws_subnet.infra-workshop-tajiri-public-a.id
}

resource "aws_subnet" "infra-workshop-tajiri-public-a" {
  vpc_id                  = aws_vpc.infra-workshop-tajiri.id
  cidr_block              = "10.0.0.0/20"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "infra-workshop-tajiri-public-a"
  }
}

resource "aws_subnet" "infra-workshop-tajiri-public-c" {
  vpc_id                  = aws_vpc.infra-workshop-tajiri.id
  cidr_block              = "10.0.16.0/20"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "infra-workshop-tajiri-public-c"
  }
}

resource "aws_subnet" "infra-workshop-tajiri-public-d" {
  vpc_id                  = aws_vpc.infra-workshop-tajiri.id
  cidr_block              = "10.0.32.0/20"
  availability_zone       = "ap-northeast-1d"
  map_public_ip_on_launch = true

  tags = {
    Name = "infra-workshop-tajiri-public-d"
  }
}

resource "aws_route_table_association" "rta-public-a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.infra-workshop-tajiri-public-a.id
}

resource "aws_route_table_association" "rta-public-c" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.infra-workshop-tajiri-public-c.id
}

resource "aws_route_table_association" "rta-public-d" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.infra-workshop-tajiri-public-d.id
}

output "infra-workshop-tajiri-public-a" {
  value = aws_subnet.infra-workshop-tajiri-public-a
}

output "infra-workshop-tajiri-public-c" {
  value = aws_subnet.infra-workshop-tajiri-public-c
}

output "infra-workshop-tajiri-public-d" {
  value = aws_subnet.infra-workshop-tajiri-public-d
}
