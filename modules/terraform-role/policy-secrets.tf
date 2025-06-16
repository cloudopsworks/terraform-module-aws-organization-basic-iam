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

# resource "aws_iam_role_policy" "terraform_access_secrets_reader" {
#   count  = try(var.settings.secrets_manager, false) ? 1 : 0
#   name   = "SecretsReader"
#   role   = aws_iam_role.terraform_access.name
#   policy = data.aws_iam_policy_document.tf_secrets_reader[0].json
# }

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
    sid    = "SecretsManagerListAdmin"
    effect = "Allow"
    actions = [
      "secretsmanager:BatchGetSecretValue",
      "secretsmanager:ListSecrets"
    ]
    resources = ["*"]
  }
}

# resource "aws_iam_role_policy" "terraform_access_secrets_admin" {
#   count  = try(var.settings.secrets_manager, false) ? 1 : 0
#   name   = "SecretsAdmin"
#   role   = aws_iam_role.terraform_access.name
#   policy = data.aws_iam_policy_document.tf_secrets_admin[0].json
# }

data "aws_iam_policy_document" "secrets_cross_account" {
  count = length(var.secrets_manager_policy) > 0 ? 1 : 0
  statement {
    sid    = "SecretsManagerCrossAccount"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = [
      var.secrets_manager_policy.secret_arn
    ]
  }
  statement {
    sid    = "SecretsManagerCrossAccountKms"
    effect = "Allow"
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      var.secrets_manager_policy.kms_key_arn
    ]
  }
}

# resource "aws_iam_role_policy" "terraform_access_secrets_cross_account" {
#   count  = length(var.secrets_manager_policy) > 0 ? 1 : 0
#   name   = "SecretsManagerCrossAccountPolicy"
#   role   = aws_iam_role.terraform_access.name
#   policy = data.aws_iam_policy_document.secrets_cross_account[0].json
# }
