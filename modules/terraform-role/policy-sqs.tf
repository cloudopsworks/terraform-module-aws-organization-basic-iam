# SQS Admin Policy
data "aws_iam_policy_document" "tf_sqs_admin" {
  version = "2012-10-17"
  statement {
    sid = "AllowRead"
    actions = [
      "sqs:*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "terraform_access_sqs_admin" {
  name   = "SQSAdmin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_sqs_admin.json
}

