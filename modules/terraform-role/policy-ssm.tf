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
    sid    = "SSMRunCommands"
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
    sid    = "SSMDocumentsAndChangeCalendar"
    effect = "Allow"
    actions = [
      "ssm:CreateDocument*",
      "ssm:UpdateDocument*",
      "ssm:DeleteDocument*",
      "ssm:GetDocument*",
      "ssm:ListDocuments",
      "ssm:ListDocument*",
      "ssm:DescribeDocument*",
      "ssm:GetCalendarState",
      "ssm:PutCalendar",
      "ssm:GetCalendar",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "SSMAssociationManageActions"
    effect = "Allow"
    actions = [
      "ssm:CreateAssociation",
      "ssm:UpdateAssociation",
      "ssm:DeleteAssociation",
      "ssm:DescribeAssociation",
      "ssm:DescribeAssociationExecutionTargets",
      "ssm:DescribeAssociationExecutions",
      "ssm:ListAssociations",
      "ssm:ListAssociationVersions",
      "ssm:ListTagsForResource",
      "ssm:AddTagsToResource",
      "ssm:RemoveTagsFromResource",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateAssociationExecutionTarget",
      "ssm:UpdateAssociationExecution",
      "ssm:UpdateAssociationDefaultVersion"
    ]
    resources = ["*"]
  }

  # Inventory Resource Data Sync (aws_ssm_resource_data_sync)
  statement {
    sid    = "SSMResourceDataSyncActions"
    effect = "Allow"
    actions = [
      "ssm:CreateResourceDataSync",
      "ssm:UpdateResourceDataSync",
      "ssm:DeleteResourceDataSync",
      "ssm:ListResourceDataSync",
    ]
    resources = ["*"]
  }

  # Patch baseline lookups feeding Quick Setup patch policies (data.aws_ssm_patch_baselines)
  statement {
    sid    = "SSMPatchBaselineReadActions"
    effect = "Allow"
    actions = [
      "ssm:DescribePatchBaselines",
      "ssm:GetPatchBaseline",
      "ssm:GetDefaultPatchBaseline",
      "ssm:GetPatchBaselineForPatchGroup",
      "ssm:DescribeEffectivePatchesForPatchBaseline",
    ]
    resources = ["*"]
  }

  # Quick Setup configuration managers (aws_ssmquicksetup_configuration_manager).
  # Quick Setup provisions its own CloudFormation stack sets and IAM roles, which are
  # granted by the CloudformationAdmin and IAM policies of this role.
  statement {
    sid    = "SSMQuickSetupActions"
    effect = "Allow"
    actions = [
      "ssm-quicksetup:CreateConfigurationManager",
      "ssm-quicksetup:UpdateConfigurationManager",
      "ssm-quicksetup:UpdateConfigurationDefinition",
      "ssm-quicksetup:DeleteConfigurationManager",
      "ssm-quicksetup:GetConfigurationManager",
      "ssm-quicksetup:GetConfiguration",
      "ssm-quicksetup:ListConfigurationManagers",
      "ssm-quicksetup:ListConfigurations",
      "ssm-quicksetup:ListQuickSetupTypes",
      "ssm-quicksetup:GetServiceSettings",
      "ssm-quicksetup:UpdateServiceSettings",
      "ssm-quicksetup:ListTagsForResource",
      "ssm-quicksetup:TagResource",
      "ssm-quicksetup:UntagResource",
    ]
    resources = ["*"]
  }

  # GUI Connect RDP connection recording preferences
  # (awscc_ssmguiconnect_preferences / AWS::SSMGuiConnect::Preferences).
  # The Cloud Control update and delete handlers both require Delete on top of Get/Update.
  statement {
    sid    = "SSMGUIConnectActions"
    effect = "Allow"
    actions = [
      "ssm-guiconnect:GetConnectionRecordingPreferences",
      "ssm-guiconnect:UpdateConnectionRecordingPreferences",
      "ssm-guiconnect:DeleteConnectionRecordingPreferences",
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
