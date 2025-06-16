# AWS Backup Policy
data "aws_iam_policy_document" "tf_securityhub_admin" {
  count   = try(var.settings.security_hub, false) ? 1 : 0
  version = "2012-10-17"
  statement {
    sid = "SecHubAllowAll"
    actions = [
      "securityhub:*",
    ]

    resources = [
      "*",
    ]
  }
}

# resource "aws_iam_role_policy" "terraform_access_securityhub_admin" {
#   count  = try(var.settings.security_hub, false) ? 1 : 0
#   name   = "SecurityHubAdmin"
#   role   = aws_iam_role.terraform_access.name
#   policy = data.aws_iam_policy_document.tf_securityhub_admin[count.index].json
# }
#
