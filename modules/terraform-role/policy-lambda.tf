# Lambda Admin Policy
data "aws_iam_policy_document" "tf_lambda_admin" {
  count   = try(var.settings.lambda, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "lambda:List*",
      "lambda:GetAccountSettings",
      "lambda:CreateEventSourceMapping",
      "lambda:GetEventSourceMapping",
      "lambda:UpdateEventSourceMapping",
      "lambda:DeleteEventSourceMapping",
      "lambda:CreateCodeSigningConfig",
      "lambda:UpdateCodeSigningConfig",
      "lambda:GetCodeSigningConfig",
      "lambda:DeleteCodeSigningConfig",
    ]
    resources = ["*"]
  }

  # function:* also matches qualified (version/alias) function ARNs.
  statement {
    effect  = "Allow"
    actions = ["lambda:*"]
    resources = [
      "arn:aws:lambda:*:*:layer:*",
      "arn:aws:lambda:*:${var.account_id}:function:*",
      "arn:aws:lambda:*:${var.account_id}:code-signing-config:*",
      "arn:aws:lambda:*:${var.account_id}:event-source-mapping:*",
    ]
  }

  dynamic "statement" {
    for_each = length(var.allowed_pass_roles) > 0 ? [1] : []
    content {
      effect    = "Allow"
      actions   = ["iam:PassRole"]
      resources = var.allowed_pass_roles
    }
  }
}

resource "aws_iam_role_policy" "terraform_access_lambda_admin" {
  count  = try(var.settings.lambda, false) ? 1 : 0
  name   = "LambdaAdminAccess"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_lambda_admin[count.index].json
}
