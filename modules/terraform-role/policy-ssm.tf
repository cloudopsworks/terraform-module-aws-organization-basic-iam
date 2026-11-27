# SSM Parameter Store reader/writer policy
# Action lists use wildcards where the pattern matches exactly the intended actions, to keep
# this inline policy small: it counts toward the role's 10,240-character inline aggregate.
data "aws_iam_policy_document" "tf_ssm_store" {
  count   = try(var.settings.ssm, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "ssm:PutParameter",
      "ssm:DeleteParameter*", # DeleteParameter, DeleteParameters
      "ssm:GetParameter*",    # GetParameter, GetParameters, GetParametersByPath, GetParameterHistory
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
      "ssm:*ServiceSetting", # Get, Update, Reset
      "ssm:ExecuteAPI",
      "ssm:GetManifest",
      "ssm:PutConfigurePackageResult",
      "ssm:*Tags*Resource", # AddTagsToResource, RemoveTagsFromResource, ListTagsForResource
      # Run Command
      "ssm:SendCommand",
      "ssm:ListCommand*", # ListCommands, ListCommandInvocations
      "ssm:GetCommandInvocation",
      "ssm:CancelCommand",
      # Maintenance Windows: create/update/delete/describe/get/list, target and task
      # (de)registration, and CancelMaintenanceWindowExecution.
      "ssm:*MaintenanceWindow*",
      # Documents and Change Calendar. ModifyDocumentPermission (document sharing) is
      # deliberately not granted, so these are not collapsed into ssm:*Document*.
      "ssm:CreateDocument*",
      "ssm:UpdateDocument*",
      "ssm:DeleteDocument*",
      "ssm:GetDocument*",
      "ssm:ListDocument*",
      "ssm:DescribeDocument*",
      "ssm:GetCalendar*", # GetCalendar, GetCalendarState
      "ssm:PutCalendar",
      # State Manager associations
      "ssm:CreateAssociation",
      "ssm:UpdateAssociation*",
      "ssm:DeleteAssociation",
      "ssm:DescribeAssociation*",
      "ssm:ListAssociation*", # ListAssociations, ListAssociationVersions
      # Inventory Resource Data Sync (aws_ssm_resource_data_sync): Create, Update, Delete, List
      "ssm:*ResourceDataSync",
      # Patch baseline lookups feeding Quick Setup patch policies (data.aws_ssm_patch_baselines)
      "ssm:DescribePatchBaselines",
      "ssm:GetPatchBaseline*", # GetPatchBaseline, GetPatchBaselineForPatchGroup
      "ssm:GetDefaultPatchBaseline",
      "ssm:DescribeEffectivePatchesForPatchBaseline",
      # Quick Setup configuration managers (aws_ssmquicksetup_configuration_manager and
      # awscc_ssmquicksetup_configuration_manager). The wildcard equals the full list of
      # ssm-quicksetup actions. Quick Setup provisions its own IAM roles, granted by the IAM
      # policy of this role.
      "ssm-quicksetup:*",
      # GUI Connect RDP connection recording preferences
      # (awscc_ssmguiconnect_preferences / AWS::SSMGuiConnect::Preferences): Get, Update, Delete.
      # The Cloud Control update and delete handlers both require Delete on top of Get/Update.
      "ssm-guiconnect:*ConnectionRecordingPreferences",
    ]
    resources = ["*"]
  }

  # CloudFormation access needed by the resources above, skipped when settings.cloudformation
  # already grants cloudformation:* through the CloudformationAdmin policy.
  # - Cloud Control API (awscc provider) authorizes as cloudformation:*Resource* actions
  #   (Create/Get/Update/Delete/ListResources, GetResourceRequestStatus, CancelResourceRequest)
  #   and does not accept a resource-level ARN.
  # - Quick Setup configuration managers deploy CloudFormation stacks and stack sets.
  dynamic "statement" {
    for_each = try(var.settings.cloudformation, false) ? [] : [1]
    content {
      effect = "Allow"
      actions = [
        "cloudformation:*Resource*",
        "cloudformation:*Stack*",
      ]
      resources = ["*"]
    }
  }
}

resource "aws_iam_role_policy" "terraform_access_ssm_store" {
  count  = try(var.settings.ssm, false) ? 1 : 0
  name   = "SSMParameterStoreWriter"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_ssm_store[count.index].json
}
