# Secrets Manager Reader Policy
data "aws_iam_policy_document" "tf_secrets_reader" {
  count   = try(var.settings.secrets_manager, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    sid    = "SecretsManagerRead"
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = [
      "arn:aws:secretsmanager:*:${var.account_id}:secret:*"
    ]
  }

  statement {
    sid    = "SecretsManagerList"
    effect = "Allow"
    actions = [
      "secretsmanager:GetRandomPassword",
      "secretsmanager:ListSecrets"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "terraform_access_secrets_reader" {
  count  = try(var.settings.secrets_manager, false) ? 1 : 0
  name   = "SecretsReader"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_secrets_reader[0].json
}

# Secrets Manager Reader Policy
data "aws_iam_policy_document" "tf_secrets_admin" {
  count   = try(var.settings.secrets_manager, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    sid    = "SecretsManagerAdmin"
    effect = "Allow"
    actions = [
      "secretsmanager:*",
    ]
    resources = [
      "arn:aws:secretsmanager:*:${var.account_id}:secret:*"
    ]
  }

  statement {
    sid    = "SecretsManagerList"
    effect = "Allow"
    actions = [
      "secretsmanager:BatchGetSecretValue",
      "secretsmanager:ListSecrets"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "terraform_access_secrets_admin" {
  count  = try(var.settings.secrets_manager, false) ? 1 : 0
  name   = "SecretsAdmin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_secrets_admin[0].json
}

