# AWS Backup Policy
data "aws_iam_policy_document" "tf_cloudtrail_admin" {
  count   = try(var.settings.cloudtrail, false) ? 1 : 0
  version = "2012-10-17"
  statement {
    sid = "CloudtrailAllowAll"
    actions = [
      "cloudtrail:*",
    ]
    resources = [
      "*",
    ]
  }
}

# resource "aws_iam_role_policy" "terraform_access_cloudtrail_admin" {
#   count  = try(var.settings.cloudtrail, false) ? 1 : 0
#   name   = "ConfigAdmin"
#   role   = aws_iam_role.terraform_access.name
#   policy = data.aws_iam_policy_document.tf_cloudtrail_admin[count.index].json
# }
#
