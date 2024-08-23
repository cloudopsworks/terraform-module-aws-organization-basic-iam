# Lambda Admin Policy
data "aws_iam_policy_document" "tf_lambda_admin" {
  version = "2012-10-17"

  statement {
    sid    = "LambdaAdminAccess"
    effect = "Allow"
    actions = [
      "lambda:List*",
      "lambda:GetAccountSettings",
      "lambda:CreateEventSourceMapping",
      "lambda:CreateCodeSigningConfig"
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
      "arn:aws:iam::${var.account_id}:role/*",
      "arn:aws:lambda:*:${var.account_id}:function:*:*"
    ]
  }

  statement {
    sid     = "LambdaLayersAccess"
    effect  = "Allow"
    actions = ["lambda:*"]
    resources = [
      "arn:aws:lambda:*:${var.account_id}:layer:*",
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
  name   = "LambdaAdminAccess"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_lambda_admin.json
}
