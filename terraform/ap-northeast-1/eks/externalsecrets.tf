data "aws_iam_policy_document" "externalsecrets-trust" {
  statement {
    sid     = "StagingReadonly"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.infra-workshop-k8s.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.infra-workshop_oidc_issuer}:sub"
      values   = ["system:serviceaccount:external-secrets:external-secrets"]
    }
  }
}

resource "aws_iam_role" "externalsecrets" {
  name               = "ExternalSecretsReadonlyAccess"
  assume_role_policy = data.aws_iam_policy_document.externalsecrets-trust.json
}

data "aws_iam_policy" "secretsmanager-readonly" {
  arn = "arn:aws:iam::254476272534:policy/SecretsManagerReadOnly"
}

resource "aws_iam_role_policy_attachment" "externalsecrets-readonly" {
  role       = aws_iam_role.externalsecrets.name
  policy_arn = data.aws_iam_policy.secretsmanager-readonly.arn
}
