# SQS Admin Policy
data "aws_iam_policy_document" "tf_sqs_admin" {
  count   = try(var.settings.sqs, false) ? 1 : 0
  version = "2012-10-17"
  statement {
    sid = "SQSAllowAll"
    actions = [
      "sqs:*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "terraform_access_sqs_admin" {
  count  = try(var.settings.sqs, false) ? 1 : 0
  name   = "SQSAdmin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_sqs_admin[count.index].json
}

