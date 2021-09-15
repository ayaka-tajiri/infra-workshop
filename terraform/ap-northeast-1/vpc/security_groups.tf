# eksクラスターで使うセキュリティグループを作成

resource "aws_security_group" "internal" {
  name_prefix = "vpc-internal-"
  vpc_id      = aws_vpc.infra-workshop-oharu.id

  tags = {
    Name = "infra-workshop-oharu-internal"
  }
}

# セキュリティグループルールリソースを提供します。
# 外部のセキュリティグループに追加できる単一の入力または出力グループルールを表します。
resource "aws_security_group_rule" "ingress" {
  security_group_id = aws_security_group.internal.id

  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = [aws_vpc.infra-workshop-oharu.cidr_block]
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.internal.id

  # ingress (inbound) or egress (outbound).
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  # こっちは0なんだ？？
  cidr_blocks = ["0.0.0.0/0"]
}

output "sg_internal" {
  value = aws_security_group.internal
}
