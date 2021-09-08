resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.infra-workshop-tajiri.id
}

resource "aws_route" "private_a_egress" {
  route_table_id         = aws_route_table.private_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_subnet" "infra-workshop-tajiri-private-a" {
  vpc_id            = aws_vpc.infra-workshop-tajiri.id
  cidr_block        = "10.0.48.0/20"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "infra-workshop-tajiri-private-a"
  }
}

resource "aws_subnet" "infra-workshop-tajiri-private-c" {
  vpc_id            = aws_vpc.infra-workshop-tajiri.id
  cidr_block        = "10.0.64.0/20"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "infra-workshop-tajiri-private-c"
  }
}

resource "aws_subnet" "infra-workshop-tajiri-private-d" {
  vpc_id            = aws_vpc.infra-workshop-tajiri.id
  cidr_block        = "10.0.96.0/20"
  availability_zone = "ap-northeast-1d"

  tags = {
    Name = "infra-workshop-tajiri-private-d"
  }
}

resource "aws_route_table_association" "rta_private-a-a" {
  route_table_id = aws_route_table.private_a.id
  subnet_id      = aws_subnet.infra-workshop-tajiri-private-a.id
}

resource "aws_route_table_association" "rta_private-a-c" {
  route_table_id = aws_route_table.private_a.id
  subnet_id      = aws_subnet.infra-workshop-tajiri-private-c.id
}

resource "aws_route_table_association" "rta_private-a-d" {
  route_table_id = aws_route_table.private_a.id
  subnet_id      = aws_subnet.infra-workshop-tajiri-private-d.id
}

output "infra-workshop-tajiri-private-a" {
  value = aws_subnet.infra-workshop-tajiri-private-a
}

output "infra-workshop-tajiri-private-c" {
  value = aws_subnet.infra-workshop-tajiri-private-c
}

output "infra-workshop-tajiri-private-d" {
  value = aws_subnet.infra-workshop-tajiri-private-d
}
