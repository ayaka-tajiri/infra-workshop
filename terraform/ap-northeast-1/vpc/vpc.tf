resource "aws_vpc" "infra-workshop-oharu" {
  # ここで指定されている場所が自分のものになる
  cidr_block = "10.3.0.0/16"

  tags = {
    Name = "infra_workshop_oharu"
  }
}

# このアウトプットってなんや。vpcってうつとこれが自動で取得できるのかな
output "vpc" {
  value = aws_vpc.infra-workshop-oharu
}
