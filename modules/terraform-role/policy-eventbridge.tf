# Event Bridge Admin Policy
data "aws_iam_policy_document" "tf_eventbridge_admin" {
  count   = try(var.settings.eventbridge, false) ? 1 : 0
  version = "2012-10-17"

  # The scheduler List*/Get*/Create*/Delete* wildcards also cover the *Schedule actions.
  statement {
    effect = "Allow"
    actions = [
      "scheduler:List*",
      "scheduler:Get*",
      "scheduler:Create*",
      "scheduler:UpdateSchedule",
      "scheduler:Delete*",
      "scheduler:Describe*",
      "scheduler:TagResource",
      "scheduler:UntagResource",
      "events:List*",
      "events:Describe*",
      "events:Create*",
      "events:Put*",
      "events:Get*",
      "events:Delete*",
      "events:TagResource",
      "events:UntagResource",
      "events:Remove*",
      "events:AllowVendedLogDeliveryForResource",
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
