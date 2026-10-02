# Cloud Watch Policy
data "aws_iam_policy_document" "tf_cloudwatch_admin" {
  count   = try(var.settings.cloudwatch, false) ? 1 : 0
  version = "2012-10-17"

  # logs:* on "*" already covers every account-scoped logs ARN.
  statement {
    effect = "Allow"
    actions = [
      "logs:*",
      "synthetics:*",
      "application-signals:*",
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:EnableAlarmActions",
      "cloudwatch:DisableAlarmActions",
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
