# Event Bridge Admin Policy
data "aws_iam_policy_document" "tf_eventbridge_admin" {
  count   = try(var.settings.eventbridge, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    sid    = "AllowAdminSchedule"
    effect = "Allow"
    actions = [
      "scheduler:ListSchedules",
      "scheduler:GetSchedule",
      "scheduler:CreateSchedule",
      "scheduler:UpdateSchedule",
      "scheduler:DeleteSchedule"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowAdminScheduleGroups"
    effect = "Allow"
    actions = [
      "scheduler:ListScheduleGroups",
      "scheduler:GetScheduleGroup",
      "scheduler:CreateScheduleGroup",
      "scheduler:DeleteScheduleGroup",
      "scheduler:ListTagsForResource",
      "scheduler:TagResource",
      "scheduler:UntagResource"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "terraform_access_eventbridge_admin" {
  count  = try(var.settings.eventbridge, false) ? 1 : 0
  name   = "EventBridgeAdmin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_eventbridge_admin[count.index].json
}
