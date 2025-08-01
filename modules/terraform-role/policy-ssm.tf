# SSM Parameter Store reader/writer policy
data "aws_iam_policy_document" "tf_ssm_store" {
  count   = try(var.settings.ssm, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    sid    = "SSMParameterActions"
    effect = "Allow"
    actions = [
      "ssm:PutParameter",
      "ssm:DeleteParameter",
      "ssm:RemoveTagsFromResource",
      "ssm:GetParameterHistory",
      "ssm:AddTagsToResource",
      "ssm:ListTagsForResource",
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter",
      "ssm:DeleteParameters"
    ]
    resources = [
      "arn:aws:ssm:*:${var.account_id}:parameter/*", # Account Parameters
      "arn:aws:ssm:*::parameter/*"                   # Global parameters
    ]
  }

  statement {
    sid    = "SSMAllowAdmin"
    effect = "Allow"
    actions = [
      "ssm:DescribeParameters",
      "ssm:GetServiceSetting",
      "ssm:UpdateServiceSetting",
      "ssm:ResetServiceSetting",
      "ssm:ExecuteAPI",
      "ssm:GetManifest",
      "ssm:PutConfigurePackageResult",
      "ssm:AddTagsToResource",
      "ssm:RemoveTagsFromResource",
    ]
    resources = ["*"]
  }

  statement {
    sid = "SSMRunCommands"
    effect = "Allow"
    actions = [
      "ssm:SendCommand",
      "ssm:ListCommands",
      "ssm:ListCommandInvocations",
      "ssm:GetCommandInvocation",
      "ssm:CancelCommand"
    ]
    resources = ["*"]
  }

  statement {
    sid = "SSMDocumentsAndChangeCalendar"
    effect = "Allow"
    actions = [
      "ssm:CreateDocument",
      "ssm:UpdateDocument",
      "ssm:DeleteDocument",
      "ssm:GetDocument",
      "ssm:ListDocuments",
      "ssm:ListDocumentVersions",
      "ssm:DescribeDocument",
      "ssm:GetCalendarState",
      "ssm:PutCalendar",
      "ssm:GetCalendar",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "terraform_access_ssm_store" {
  count  = try(var.settings.ssm, false) ? 1 : 0
  name   = "SSMParameterStoreWriter"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_ssm_store[count.index].json
}
