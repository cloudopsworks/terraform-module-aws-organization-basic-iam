# AWS Backup Policy
data "aws_iam_policy_document" "tf_config_admin" {
  count   = try(var.settings.awsconfig, false) ? 1 : 0
  version = "2012-10-17"
  statement {
    sid = "AllowRead"
    actions = [
      "config:*",
    ]

    resources = [
      "*",
    ]
  }
}
#
# resource "aws_iam_role_policy" "terraform_access_config_admin" {
#   count  = try(var.settings.awsconfig, false) ? 1 : 0
#   name   = "ConfigAdmin"
#   role   = aws_iam_role.terraform_access.name
#   policy = data.aws_iam_policy_document.tf_config_admin[count.index].json
# }
#
