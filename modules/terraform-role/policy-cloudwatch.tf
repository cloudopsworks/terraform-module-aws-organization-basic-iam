# Cloud Watch Policy
data "aws_iam_policy_document" "tf_cloudwatch_admin" {
  version = "2012-10-17"
  statement {
    sid    = "AllowCloudWatchAdmin"
    effect = "Allow"
    actions = [
      "logs:*",
    ]
    resources = ["*"]
  }

  statement {
    sid       = "AllowCloudWatchLogs"
    effect    = "Allow"
    actions   = ["logs:*"]
    resources = ["arn:aws:logs:*:${var.account_id}:*"]
  }

  statement {
    sid     = "AllowCloudWatchMetrics"
    effect  = "Allow"
    actions = ["logs:*"]
    resources = [
      "arn:aws:logs:*:${var.account_id}:destination:*",
      "arn:aws:logs:*:${var.account_id}:log-group:*:log-stream:*"
    ]
  }
}

resource "aws_iam_role_policy" "terraform_access_cloudwatch_admin" {
  name   = "CloudwatchLogsAdmin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_cloudwatch_admin.json
}
