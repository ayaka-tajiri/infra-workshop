resource "aws_security_group" "internal" {
  name_prefix = "vpc-internal-"
  vpc_id      = aws_vpc.infra-workshop-tajiri.id

  tags = {
    Name = "infra-workshop-tajiri-internal"
  }
}

resource "aws_security_group_rule" "ingress" {
  security_group_id = aws_security_group.internal.id

  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = [aws_vpc.infra-workshop-tajiri.cidr_block]
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.internal.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "sg_internal" {
  value = aws_security_group.internal
}
