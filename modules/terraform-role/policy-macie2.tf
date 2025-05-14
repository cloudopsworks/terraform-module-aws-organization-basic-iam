# SQS Admin Policy
data "aws_iam_policy_document" "tf_macie2_admin" {
  count   = try(var.settings.macie2, false) ? 1 : 0
  version = "2012-10-17"
  statement {
    sid = "AllowRead"
    actions = [
      "macie2:*",
    ]

    resources = [
      "arn:aws:macie2:*:*:*",
    ]
  }
}

resource "aws_iam_role_policy" "terraform_access_macie2_admin" {
  count  = try(var.settings.macie2, false) ? 1 : 0
  name   = "Macie2Admin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_macie2_admin[count.index].json
}

