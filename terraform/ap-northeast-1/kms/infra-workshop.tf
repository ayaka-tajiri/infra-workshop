resource "aws_kms_key" "infra-workshop-tajiri" {
  description             = "infra-workshop encryption key"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "infra-workshop-tajiri" {
  name          = "alias/infra-workshop-tajiri"
  target_key_id = aws_kms_key.infra-workshop-tajiri.key_id
}

