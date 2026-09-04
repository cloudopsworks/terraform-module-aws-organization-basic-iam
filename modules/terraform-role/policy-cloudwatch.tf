# Cloud Watch Policy
data "aws_iam_policy_document" "tf_cloudwatch_admin" {
  count   = try(var.settings.cloudwatch, false) ? 1 : 0
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

  statement {
    sid    = "AllowAllSynthetics"
    effect = "Allow"
    actions = [
      "synthetics:*"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "AllowAllApplicationSignals"
    effect = "Allow"
    actions = [
      "application-signals:*"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "AllowAnyAlarmActions"
    effect = "Allow"
    actions = [
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:EnableAlarmActions",
      "cloudwatch:DisableAlarmActions"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "terraform_access_cloudwatch_admin" {
  count  = try(var.settings.cloudwatch, false) ? 1 : 0
  name   = "CloudwatchLogsAdmin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_cloudwatch_admin[count.index].json
}
