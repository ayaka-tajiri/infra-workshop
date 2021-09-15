resource "aws_kms_key" "infra-workshop-oharu" {
  description             = "infra-workshop encryption key"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "infra-workshop-oharu" {
  name          = "alias/infra-workshop-oharu"
  target_key_id = aws_kms_key.infra-workshop-oharu.key_id
}
