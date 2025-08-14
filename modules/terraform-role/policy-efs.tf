# EFS Admin Policy
data "aws_iam_policy_document" "tf_efs_admin" {
  count   = try(var.settings.efs, false) ? 1 : 0
  version = "2012-10-17"
  statement {
    sid    = "EFSAdmin"
    effect = "Allow"
    actions = [
      "elasticfilesystem:*",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "terraform_access_efs_admin" {
  count  = try(var.settings.efs, false) ? 1 : 0
  role   = aws_iam_role.terraform_access.name
  name   = "EFSAdmin-policy"
  policy = data.aws_iam_policy_document.tf_efs_admin[count.index].json
}