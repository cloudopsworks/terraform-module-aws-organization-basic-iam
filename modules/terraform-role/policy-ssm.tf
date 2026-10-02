# SSM Parameter Store reader/writer policy
data "aws_iam_policy_document" "tf_ssm_store" {
  count   = try(var.settings.ssm, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "ssm:PutParameter",
      "ssm:DeleteParameter",
      "ssm:GetParameterHistory",
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter",
      "ssm:DeleteParameters",
    ]
    resources = [
      "arn:aws:ssm:*:${var.account_id}:parameter/*", # Account Parameters
      "arn:aws:ssm:*::parameter/*"                   # Global parameters
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      # Service settings and tagging
      "ssm:DescribeParameters",
      "ssm:GetServiceSetting",
      "ssm:UpdateServiceSetting",
      "ssm:ResetServiceSetting",
      "ssm:ExecuteAPI",
      "ssm:GetManifest",
      "ssm:PutConfigurePackageResult",
      "ssm:AddTagsToResource",
      "ssm:RemoveTagsFromResource",
      "ssm:ListTagsForResource",
      # Run Command
      "ssm:SendCommand",
      "ssm:ListCommands",
      "ssm:ListCommandInvocations",
      "ssm:GetCommandInvocation",
      "ssm:CancelCommand",
      # Maintenance Windows
      "ssm:CreateMaintenanceWindow*",
      "ssm:UpdateMaintenanceWindow*",
      "ssm:DeleteMaintenanceWindow*",
      "ssm:DescribeMaintenanceWindow*",
      "ssm:GetMaintenanceWindow*",
      "ssm:ListMaintenanceWindow*",
      "ssm:RegisterTargetWithMaintenanceWindow",
      "ssm:DeregisterTargetFromMaintenanceWindow",
      "ssm:RegisterTaskWithMaintenanceWindow",
      "ssm:DeregisterTaskFromMaintenanceWindow",
      # Documents and Change Calendar
      "ssm:CreateDocument*",
      "ssm:UpdateDocument*",
      "ssm:DeleteDocument*",
      "ssm:GetDocument*",
      "ssm:ListDocument*",
      "ssm:DescribeDocument*",
      "ssm:GetCalendarState",
      "ssm:PutCalendar",
      "ssm:GetCalendar",
      # State Manager associations
      "ssm:CreateAssociation",
      "ssm:UpdateAssociation",
      "ssm:DeleteAssociation",
      "ssm:DescribeAssociation",
      "ssm:DescribeAssociationExecutionTargets",
      "ssm:DescribeAssociationExecutions",
      "ssm:ListAssociations",
      "ssm:ListAssociationVersions",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateAssociationExecutionTarget",
      "ssm:UpdateAssociationExecution",
      "ssm:UpdateAssociationDefaultVersion",
      # Inventory Resource Data Sync (aws_ssm_resource_data_sync)
      "ssm:CreateResourceDataSync",
      "ssm:UpdateResourceDataSync",
      "ssm:DeleteResourceDataSync",
      "ssm:ListResourceDataSync",
      # Patch baseline lookups feeding Quick Setup patch policies (data.aws_ssm_patch_baselines)
      "ssm:DescribePatchBaselines",
      "ssm:GetPatchBaseline",
      "ssm:GetDefaultPatchBaseline",
      "ssm:GetPatchBaselineForPatchGroup",
      "ssm:DescribeEffectivePatchesForPatchBaseline",
      # Quick Setup configuration managers (aws_ssmquicksetup_configuration_manager).
      # Quick Setup provisions its own CloudFormation stack sets and IAM roles, which are
      # granted by the CloudformationAdmin and IAM policies of this role.
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
      # GUI Connect RDP connection recording preferences
      # (awscc_ssmguiconnect_preferences / AWS::SSMGuiConnect::Preferences).
      # The Cloud Control update and delete handlers both require Delete on top of Get/Update.
      "ssm-guiconnect:GetConnectionRecordingPreferences",
      "ssm-guiconnect:UpdateConnectionRecordingPreferences",
      "ssm-guiconnect:DeleteConnectionRecordingPreferences",
      # The awscc provider drives awscc_ssmguiconnect_preferences through the Cloud Control
      # API, whose operations authorize as cloudformation:*Resource actions rather than the
      # classic stack actions. Cloud Control does not accept a resource-level ARN for these.
      "cloudformation:CreateResource",
      "cloudformation:GetResource",
      "cloudformation:UpdateResource",
      "cloudformation:DeleteResource",
      "cloudformation:ListResources",
      "cloudformation:GetResourceRequestStatus",
      "cloudformation:CancelResourceRequest",
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
