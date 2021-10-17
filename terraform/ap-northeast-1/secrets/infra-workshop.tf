data "aws_kms_secrets" "database-infra-workshop" {
  secret {
    name    = "master_key"
    payload = "AQICAHjBrxo2dc84Dus4Uc9bcpL6eZBWe189yf5HABvo+0Cw5AEYo5Up749tG396pjKOoQW0AAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMciCnlQLRwMLhygU6AgEQgDuDU8RmEShv+Ta31ZfShpUdhmY7SoCBEm9/xvkOWJClUjeRvbfkNhAeoPAMTjNMwPr0M260pMKwrNLbLQ=="

    context = {
      service = "infra-workshop"
    }
  }
}

data "aws_kms_secrets" "auth-infra-workshop" {
  secret {
    name    = "auth"
    payload = "AQICAHjBrxo2dc84Dus4Uc9bcpL6eZBWe189yf5HABvo+0Cw5AFbWllGPFbKcJuR7xk8cFqiAAAAjDCBiQYJKoZIhvcNAQcGoHwwegIBADB1BgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDFbbN+EtMOCP4RfI1AIBEIBIgGKxGbuMUy8LZxVU9JSzqrciKe7qVzNIe567+KUX0SLW7QF1PblKQlc+zoGFgaCRmwAQU8i/vDqoORd+3gPDXQWzJCneQ6Tb"

    context = {
      service = "infra-workshop"
    }
  }
}

locals {
  infra-workshop-tajiri = {
    master_key = data.aws_kms_secrets.database-infra-workshop.plaintext["master_key"]
    auth = data.aws_kms_secrets.auth-infra-workshop.plaintext["auth"]
  }

  infra-workshop-tajiri-auth = {
    auth = data.aws_kms_secrets.auth-infra-workshop.plaintext["auth"]
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

resource "aws_secretsmanager_secret" "infra-workshop-tajiri-auth" {
  name        = "/infra-workshop-tajiri/basic-auth"
  description = "Credentials basic-auth"

  recovery_window_in_days = 7

  tags = {
    type = "auth"
  }
}

resource "aws_secretsmanager_secret_version" "infra-workshop-tajiri" {
  secret_id     = aws_secretsmanager_secret.infra-workshop-tajiri.id
  secret_string = jsonencode(local.infra-workshop-tajiri)
}

resource "aws_secretsmanager_secret_version" "infra-workshop-tajiri-auth" {
  secret_id     = aws_secretsmanager_secret.infra-workshop-tajiri-auth.id
  secret_string = jsonencode(local.infra-workshop-tajiri-auth)
}
