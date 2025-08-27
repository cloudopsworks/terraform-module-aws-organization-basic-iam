# Lambda Admin Policy
data "aws_iam_policy_document" "tf_lambda_admin" {
  count   = try(var.settings.lambda, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    sid    = "LambdaAdminAccess"
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

  statement {
    sid    = "LambdaFunctionsAccess"
    effect = "Allow"
    actions = [
      "iam:PassRole",
      "lambda:*"
    ]
    resources = [
      "arn:aws:iam::${var.account_id}:role/*", # TODO: Restrict this further
      "arn:aws:lambda:*:${var.account_id}:function:*:*"
    ]
  }

  statement {
    sid     = "LambdaLayersAccess"
    effect  = "Allow"
    actions = ["lambda:*"]
    resources = [
      "arn:aws:lambda:*:*:layer:*",
      "arn:aws:lambda:*:${var.account_id}:function:*"
    ]
  }

  statement {
    sid     = "LambdaCodeSignAccess"
    effect  = "Allow"
    actions = ["lambda:*"]
    resources = [
      "arn:aws:lambda:*:${var.account_id}:code-signing-config:*",
      "arn:aws:lambda:*:${var.account_id}:event-source-mapping:*"
    ]
  }
}

resource "aws_iam_role_policy" "terraform_access_lambda_admin" {
  count  = try(var.settings.lambda, false) ? 1 : 0
  name   = "LambdaAdminAccess"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_lambda_admin[count.index].json
}
