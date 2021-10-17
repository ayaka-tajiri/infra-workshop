resource "aws_route_table" "public" {
  vpc_id = aws_vpc.infra-workshop-tajiri.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_gw.id
  }

  tags = {
    "Name" = "infra-workwhop public route table"
    "VPC" =  "infra-workshop"
  }
}

resource "aws_internet_gateway" "vpc_gw" {
  vpc_id = aws_vpc.infra-workshop-tajiri.id
}

resource "aws_eip" "public" {
  vpc = true

  tags = {
    "VPC" = "infra-workshop"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.public.id
  subnet_id     = random_shuffle.nat_subnet.result[0]

  tags = {
    "Type" = "Public"
    "VPC" = "infra-workshop"
  }
}

  resource "aws_subnet" "infra-workshop-public" {
  count = length(var.region_azs)

  vpc_id                  = aws_vpc.infra-workshop-tajiri.id
  cidr_block              = "${var.cidr_prefix}.${var.public_cidr_postfix[count.index]}/20"
  availability_zone       = "${var.vpc_region}${var.region_azs[count.index]}"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "infra-workshop Public"
    "VPC" = "infra-workshop"
  }
}

resource "random_shuffle" "nat_subnet" {
  input        = aws_subnet.infra-workshop-public.*.id
  result_count = 1
}

resource "aws_route_table_association" "rta-public" {
  count = length(var.region_azs)

  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.infra-workshop-public[count.index].id
}

output "infra-workshop-public-subnet-ids" {
  value = aws_subnet.infra-workshop-public.*.id
}
