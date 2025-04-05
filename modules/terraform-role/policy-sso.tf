# SSO Admin Policy

data "aws_iam_policy_document" "tf_sso_admin" {
  count   = var.is_org && try(var.settings.sso, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    sid    = "SSOAdmin"
    effect = "Allow"
    actions = [
      "sso:*",
      "sso-directory:*",
      "identitystore:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "terraform_access_sso_admin" {
  count  = var.is_org && try(var.settings.sso, false) ? 1 : 0
  name   = "SSOAdmin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_sso_admin[0].json
}
