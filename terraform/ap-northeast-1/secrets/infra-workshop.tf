data "aws_kms_secrets" "database-infra-workshop" {
  secret {
    name    = "master_key"
    payload = "AQICAHg6hcg/pjmyt0PydSpCd7tEpzHhJYPj/EaYuZifN8LLRAFMZTzuCErOQ9IKHOTfX7b1AAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMLgiQdOxhs3fh1XPvAgEQgDt8DlUswF6rfQgLQ7qk9x0Zuby7VV6hSTtdVOU0/guorbwvH3w9553OumNINjFp/XSLcUNGiSN61lYQgw=="

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
