# SES Admin Policy
data "aws_iam_policy_document" "tf_ses_admin" {
  count   = try(var.settings.ses, false) ? 1 : 0
  version = "2012-10-17"
  statement {
    sid = "SESAllowAll"
    actions = [
      "ses:*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "terraform_access_ses_admin" {
  count  = try(var.settings.ses, false) ? 1 : 0
  name   = "SESAdmin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_ses_admin[count.index].json
}

