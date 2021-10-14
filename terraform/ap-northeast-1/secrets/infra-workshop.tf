data "aws_kms_secrets" "database-infra-workshop" {
  secret {
    name    = "master_key"
    payload = "AQICAHjBrxo2dc84Dus4Uc9bcpL6eZBWe189yf5HABvo+0Cw5AEYo5Up749tG396pjKOoQW0AAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMciCnlQLRwMLhygU6AgEQgDuDU8RmEShv+Ta31ZfShpUdhmY7SoCBEm9/xvkOWJClUjeRvbfkNhAeoPAMTjNMwPr0M260pMKwrNLbLQ=="

    context = {
      service = "infra-workshop"
    }
  }
}

locals {
  infra-workshop-tajiri = {
    master_key = data.aws_kms_secrets.database-infra-workshop.plaintext["master_key"]
  }
}

resource "aws_secretsmanager_secret" "infra-workshop-tajiri" {
  name        = "/infra-workshop-tajiri/rails"
  description = "Credentials rails for infra workshop"

  recovery_window_in_days = 7

  tags = {
    type = "key"
  }
}

resource "aws_secretsmanager_secret_version" "infra-workshop-tajiri" {
  secret_id     = aws_secretsmanager_secret.infra-workshop-tajiri.id
  secret_string = jsonencode(local.infra-workshop-tajiri)
}
