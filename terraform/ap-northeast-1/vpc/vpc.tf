resource "aws_vpc" "infra-workshop-tajiri" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "infra_workshop_tajiri"
  }
}

output "vpc" {
  value = aws_vpc.infra-workshop-tajiri
}
