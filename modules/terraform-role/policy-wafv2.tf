# WAFv2 Admin Policy
data "aws_iam_policy_document" "tf_wafv2_admin" {
  count   = try(var.settings.wafv2, var.settings.waf, var.settings.waf_v2, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    sid    = "WAFv2AllAccess"
    effect = "Allow"
    actions = [
      "wafv2:*",
    ]
    resources = [
      "arn:aws:wafv2:*:${var.account_id}:*"
    ]
  }
}
