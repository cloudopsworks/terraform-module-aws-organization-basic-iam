# RAM policy access
data "aws_iam_policy_document" "tf_ram_policy_admin" {
  count   = try(var.settings.ram, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    sid    = "RAMAdminRole"
    effect = "Allow"
    actions = [
      "ram:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "terraform_access_ram_admin" {
  count  = try(var.settings.ram, false) ? 1 : 0
  name   = "RAMAdmin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_ram_policy_admin[count.index].json
}
