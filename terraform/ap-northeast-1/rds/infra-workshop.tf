resource "aws_db_subnet_group" "infra-workshop" {
  name = "infra-workshop-database-tajiri"
  subnet_ids = data.terraform_remote_state.vpc.outputs.infra-workshop-private_subnet_ids
}

data "aws_kms_secrets" "database-infra-workshop" {
  secret {
    name    = "password"
    payload = "AQICAHjBrxo2dc84Dus4Uc9bcpL6eZBWe189yf5HABvo+0Cw5AH6siBesE2/jpHZgB8RlKDrAAAAZjBkBgkqhkiG9w0BBwagVzBVAgEAMFAGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMxuzaRda8AZMn32LJAgEQgCPYCMRfN3ZQ0okzUA0Vb2WaJ6rgKNLUq7FfmfvsSDmqDozYvA=="

    context = {
      service = "infra-workshop"
    }
  }
}

locals {
  infra-workshop-tajiri = {
    password = data.aws_kms_secrets.database-infra-workshop.plaintext["password"]
  }
}

resource "aws_secretsmanager_secret" "infra-workshop-tajiri" {
  name        = "/infra-workshop-tajiri/databases"
  description = "Credentials for infra workshop"

  recovery_window_in_days = 7

  tags = {
    type = "password"
  }
}

resource "aws_secretsmanager_secret_version" "infra-workshop-tajiri" {
  secret_id     = aws_secretsmanager_secret.infra-workshop-tajiri.id
  secret_string = jsonencode(local.infra-workshop-tajiri)
}

resource "aws_security_group" "infra-workshop" {
  name        = "infra-workshop"
  description = "Infra Workshop RDS security group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc.id
}

resource "aws_security_group_rule" "infra-workshop-ingress" {
  security_group_id = aws_security_group.infra-workshop.id

  type      = "ingress"
  from_port = "3306"
  to_port   = "3306"
  protocol  = "TCP"
  cidr_blocks = [data.terraform_remote_state.vpc.outputs.infra-workshop-private_cidr]
}

resource "aws_security_group_rule" "infra-workshop-egress" {
  security_group_id = aws_security_group.infra-workshop.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_db_parameter_group" "infra-workshop-default" {
  name   = "infra-workshop-default-tajiri"
  family = "mysql5.7"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_connection"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_results"
    value = "utf8mb4"
  }
}

resource "aws_db_instance" "infra-workshop" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  parameter_group_name = aws_db_parameter_group.infra-workshop-default.name
  skip_final_snapshot  = true

  availability_zone      = "ap-northeast-1c"
  db_subnet_group_name   = aws_db_subnet_group.infra-workshop.name
  vpc_security_group_ids = [aws_security_group.infra-workshop.id]

  name     = "infra_workshop"
  username = "app_user"
  password = data.aws_kms_secrets.database-infra-workshop.plaintext["password"]
}
