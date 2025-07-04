# AWS Access Analyzer Policy
data "aws_iam_policy_document" "tf_access_analyzer" {
  count   = try(var.settings.access_analyzer, false) ? 1 : 0
  version = "2012-10-17"
  statement {
    sid = "ConfigAllowAll"
    actions = [
      "access-analyzer:*",
    ]

    resources = [
      "*",
    ]
  }
}
