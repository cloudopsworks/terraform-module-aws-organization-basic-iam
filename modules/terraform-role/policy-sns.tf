# SNS Admin Policy
data "aws_iam_policy_document" "tf_sns_admin" {
  count   = try(var.settings.sns, false) ? 1 : 0
  version = "2012-10-17"
  statement {
    sid = "SNSAllowAll"
    actions = [
      "sns:*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "terraform_access_sns_admin" {
  count  = try(var.settings.sns, false) ? 1 : 0
  name   = "SNSAdmin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_sns_admin[count.index].json
}

