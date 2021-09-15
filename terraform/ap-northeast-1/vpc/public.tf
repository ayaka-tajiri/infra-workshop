# パブリックにアクセスできるサブネット、インターネットゲートウェイ、ナットゲートウェイルートテーブルを作成する

# サブネットリソースの作成
# resource "aws_subnet" "infra-workshop-public" {
#   # 作る個数を設定している
#   count = length(var.region_azs)

#   #vpc.tf ファイルで設定してるもの
#   vpc_id                  = aws_vpc.infra-workshop-oharu.id
#   # ここの変数にはvariablesで定義してるものが入る
#   cidr_block              = "${var.cidr_prefix}.${var.public_cidr_postfix[count.index]}/20"
#   availability_zone       = "${var.vpc_region}${var.region_azs[count.index]}"
#   # trueを指定して、サブネットに起動されたインスタンスにパブリックIPアドレスを割り当てる必要があることを示します。デフォルトはfalseです
#   map_public_ip_on_launch = true

#   tags = {
#     "Name" = "infra-workshop Public"
#     "VPC" = "infra-workshop"
#   }
# }
# 👇をかっこよく書くとこれ👆

#
# ap-northeast の availability_zone に b がないから今回はa,c,dでつくっている
# availability_zone = 各リージョン内の複数の独立した物理的なデータセンター、なので複数箇所に作っておくと安心
#

resource "aws_subnet" "infra-workshop-oharu-public-a" {
  # サブネットはvpcに紐づく
  vpc_id                  = aws_vpc.infra-workshop-oharu.id
  # VPC内のどの領域を担当するかを決める
  cidr_block              = "10.3.0.0/20"
  availability_zone       = "ap-northeast-1a"
  # trueを指定して、サブネットに起動されたインスタンスにパブリックIPアドレスを割り当てる必要があることを示します。デフォルトはfalseです。
  map_public_ip_on_launch = true

  tags = {
    Name = "infra-workshop-oharu-public-a"
  }
}

resource "aws_subnet" "infra-workshop-oharu-public-c" {
  vpc_id                  = aws_vpc.infra-workshop-oharu.id
  cidr_block              = "10.3.16.0/20"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "infra-workshop-oharu-public-c"
  }
}

resource "aws_subnet" "infra-workshop-oharu-public-d" {
  vpc_id                  = aws_vpc.infra-workshop-oharu.id
  cidr_block              = "10.3.32.0/20"
  availability_zone       = "ap-northeast-1d"
  map_public_ip_on_launch = true

  tags = {
    Name = "infra-workshop-oharu-public-d"
  }
}


# インターネットゲートウェイ。ミニマム vpc id を作れたらよさそう
#  この子が一般公開してくれる。これがVPCにあく穴になる。このままではどこにも繋がっていない
resource "aws_internet_gateway" "vpc_gw" {
  # 必須項目
  vpc_id = aws_vpc.infra-workshop-oharu.id
}


# Elastic IP アドレスの作成
resource "aws_eip" "public" {
  vpc = true

  tags = {
    "VPC" = "infra-workshop"
  }
}


# ナットゲートウェイ。
# プライベートIPしか持ってなくいから、外に出ていくにはパブリックIP（Elastic IP）に変換している
# 外にでていくのにこれが必要
resource "aws_nat_gateway" "nat_gw" {
  # ゲートウェイのElasticIPアドレスの割り当てID。
  allocation_id = aws_eip.public.id
  # 必須項目。ゲートウェイを配置するサブネットのサブネットID。いったんベタでサブネットを指定
  subnet_id     = aws_subnet.infra-workshop-oharu-public-a.id

  tags = {
    "Type" = "Public"
    "VPC" = "infra-workshop"
  }
}


# ルートテーブル
# サブネットとVPCに開いた穴（インターネットゲートウェイ）をつなげている
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.infra-workshop-oharu.id

  route {
    # 任意のトラフィックをこのゲートウェイに関連づける
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_gw.id
  }

  tags = {
    "Name" = "infra-workwhop public route table"
    "VPC" =  "infra-workshop"
  }
}

# サブネット分のアソシエーションを作る必要ある
# resource "aws_route_table_association" "rta-public" {
#   count = length(var.region_azs)

#   route_table_id = aws_route_table.public.id
#   subnet_id      = aws_subnet.infra-workshop-public[count.index].id
# }
#
# 👆をかっこよく書くとこれ👇


# このサブネットはこのルートテーブルを使うよ、という設定
resource "aws_route_table_association" "rta-public-a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.infra-workshop-oharu-public-a.id
}

resource "aws_route_table_association" "rta-public-c" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.infra-workshop-oharu-public-c.id
}

resource "aws_route_table_association" "rta-public-d" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.infra-workshop-oharu-public-d.id
}

# アウトプット
output "infra-workshop-oharu-public-a" {
  value = aws_subnet.infra-workshop-oharu-public-a
}

output "infra-workshop-oharu-public-c" {
  value = aws_subnet.infra-workshop-oharu-public-c
}

output "infra-workshop-oharu-public-d" {
  value = aws_subnet.infra-workshop-oharu-public-d
}
