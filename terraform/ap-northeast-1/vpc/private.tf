resource "aws_route_table" "private" {
  count = length(var.region_azs)

  vpc_id = aws_vpc.infra-workshop-tajiri.id

  tags = {
    "Name" = "infra-workshop private route table"
    "VPC" = "infra-workshop"
  }
}

resource "aws_route" "private_egress" {
  count = length(var.region_azs)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_subnet" "private" {
  count = length(var.region_azs)

  vpc_id            = aws_vpc.infra-workshop-tajiri.id
  cidr_block        = "${var.cidr_prefix}.${var.private_cidr_postfix[count.index]}/19"
  availability_zone = "${var.vpc_region}${var.region_azs[count.index]}"

  tags = {
    "Name" = "infra-workshop private subnet"
    "Type" = "Private (layer 1)"
    "VPC" = "infra-workshop"
  }
}

resource "aws_route_table_association" "rta_private" {
  count = length(var.region_azs)

  route_table_id = aws_route_table.private[count.index].id
  subnet_id      = aws_subnet.private[count.index].id
}

output "infra-workshop-private_subnet_ids" {
  value = aws_subnet.private.*.id
}
