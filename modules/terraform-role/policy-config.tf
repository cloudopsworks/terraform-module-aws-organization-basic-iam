# AWS Config Policy
data "aws_iam_policy_document" "tf_config_admin" {
  count   = try(var.settings.awsconfig, false) ? 1 : 0
  version = "2012-10-17"
  statement {
    sid = "ConfigAllowAll"
    actions = [
      "config:*",
    ]

    resources = [
      "*",
    ]
  }
}