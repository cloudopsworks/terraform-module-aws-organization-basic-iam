# IAM Full Access Policy
data "aws_iam_policy_document" "tf_iam_full" {
  count   = try(var.settings.iam, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    sid       = "IAMFullAccess"
    effect    = "Allow"
    actions   = ["iam:*"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "terraform_access_iam_full" {
  count  = try(var.settings.iam, false) ? 1 : 0
  name   = "IAMFullAccess"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_iam_full[count.index].json
}
