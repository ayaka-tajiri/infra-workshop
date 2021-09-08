data "aws_iam_policy_document" "secretsmanager-read-only" {
  statement {
    actions = [
      "secretsmanager:GetRandomPassword",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "secretsmanager-read-only" {
  name        = "SecretsManagerReadOnly"
  description = "Read only permissions for secrets manager"
  policy      = data.aws_iam_policy_document.secretsmanager-read-only.json
}

