# AWS Backup Policy
data "aws_iam_policy_document" "tf_guardduty_admin" {
  count   = try(var.settings.guard_duty, false) ? 1 : 0
  version = "2012-10-17"
  statement {
    sid = "GuardDutyAllowAll"
    actions = [
      "guardduty:*",
    ]
    resources = [
      "*",
    ]
  }
}