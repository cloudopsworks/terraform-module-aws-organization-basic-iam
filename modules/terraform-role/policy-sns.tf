# SNS Admin Policy
data "aws_iam_policy_document" "tf_sns_admin" {
  version = "2012-10-17"
  statement {
    sid = "AllowRead"
    actions = [
      "sns:*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "terraform_access_sns_admin" {
  name   = "SNSAdmin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_sns_admin.json
}

