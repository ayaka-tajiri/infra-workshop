# プライベートサブネット、ルートテーブルを作成する

# resource "aws_subnet" "private" {
#   count = length(var.region_azs)

#   vpc_id            = aws_vpc.infra-workshop-tajiri.id
#   cidr_block        = "${var.cidr_prefix}.${var.private_cidr_postfix[count.index]}/19"
#   availability_zone = "${var.vpc_region}${var.region_azs[count.index]}"

#   tags = {
#     "Name" = "infra-workshop private subnet"
#     "Type" = "Private (layer 1)"
#     "VPC" = "infra-workshop"
#   }
# }

resource "aws_subnet" "infra-workshop-oharu-private-a" {
  vpc_id                  = aws_vpc.infra-workshop-oharu.id
  cidr_block              = "10.3.48.0/20"
  availability_zone       = "ap-northeast-1a"
  # trueを指定して、サブネットに起動されたインスタンスにパブリックIPアドレスを割り当てる必要があることを示します。デフォルトはfalseです。
  map_public_ip_on_launch = true

  tags = {
    "Name" = "infra-workshop-oharu-private-a"
    "Type" = "Private (layer 1)"
    "VPC" = "infra-workshop"
  }
}

resource "aws_subnet" "infra-workshop-oharu-private-c" {
  vpc_id                  = aws_vpc.infra-workshop-oharu.id
  cidr_block              = "10.3.64.0/20"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "infra-workshop-oharu-private-c"
    "Type" = "Private (layer 1)"
    "VPC" = "infra-workshop"
  }
}

resource "aws_subnet" "infra-workshop-oharu-private-d" {
  vpc_id                  = aws_vpc.infra-workshop-oharu.id
  cidr_block              = "10.3.96.0/20"
  availability_zone       = "ap-northeast-1d"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "infra-workshop-oharu-private-d"
    "Type" = "Private (layer 1)"
    "VPC" = "infra-workshop"
  }
}


# ルートテーブル
resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.infra-workshop-oharu.id

  tags = {
    "Name" = "infra-workshop private route table"
    "VPC" = "infra-workshop"
  }
}

# ルート
resource "aws_route" "private_a_egress" {
  route_table_id         = aws_route_table.private_a.id
  destination_cidr_block = "0.0.0.0/0"
  # パブリックだとnatgateway。外部からのアクセスは禁止する。内部から外部へはアクセスできるようにするもの
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}


# アソシエーション
# resource "aws_route_table_association" "rta_private" {
#   count = length(var.region_azs)

#   route_table_id = aws_route_table.private[count.index].id
#   subnet_id      = aws_subnet.private[count.index].id
# }

resource "aws_route_table_association" "rta_private-a-a" {
  route_table_id = aws_route_table.private_a.id
  subnet_id      = aws_subnet.infra-workshop-oharu-private-a.id
}

resource "aws_route_table_association" "rta_private-a-c" {
  route_table_id = aws_route_table.private_a.id
  subnet_id      = aws_subnet.infra-workshop-oharu-private-c.id
}

resource "aws_route_table_association" "rta_private-a-d" {
  route_table_id = aws_route_table.private_a.id
  subnet_id      = aws_subnet.infra-workshop-oharu-private-d.id
}


# アウトプット
output "infra-workshop-oharu-private-a" {
  value = aws_subnet.infra-workshop-oharu-private-a
}

output "infra-workshop-oharu-private-c" {
  value = aws_subnet.infra-workshop-oharu-private-c
}

output "infra-workshop-oharu-private-d" {
  value = aws_subnet.infra-workshop-oharu-private-d
}
