# KMS Admin Policy
data "aws_iam_policy_document" "tf_kms_admin" {
  count   = try(var.settings.kms, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    sid    = "KMSAdmin"
    effect = "Allow"
    actions = [
      "kms:Describe*",
      "kms:ListKeys",
      "kms:DeleteCustomKeyStore",
      "kms:GenerateRandom",
      "kms:UpdateCustomKeyStore",
      "kms:ListAliases",
      "kms:DisconnectCustomKeyStore",
      "kms:CreateKey",
      "kms:ConnectCustomKeyStore",
      "kms:CreateCustomKeyStore"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "KMSKeyAdmin"
    effect = "Allow"
    actions = [
      "kms:CancelKeyDeletion",
      "kms:CreateAlias",
      "kms:CreateGrant",
      "kms:DeleteAlias",
      "kms:DescribeKey",
      "kms:DisableKey",
      "kms:DisableKeyRotation",
      "kms:EnableKey",
      "kms:EnableKeyRotation",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
      "kms:ListGrants",
      "kms:ListKeyPolicies",
      "kms:ListResourceTags",
      "kms:PutKeyPolicy",
      "kms:ReplicateKey",
      "kms:RevokeGrant",
      "kms:ScheduleKeyDeletion",
      "kms:TagResource",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:UntagResource",
      "kms:UpdateAlias",
      "kms:UpdateKeyDescription",
      "kms:UpdatePrimaryRegion",
    ]
    resources = [
      "arn:aws:kms:*:${var.account_id}:key/*",
      "arn:aws:kms:*:${var.account_id}:alias/*"
    ]
  }
}

# resource "aws_iam_role_policy" "terraform_access_kms_admin" {
#   count  = try(var.settings.kms, false) ? 1 : 0
#   name   = "KMSAdmin"
#   role   = aws_iam_role.terraform_access.name
#   policy = data.aws_iam_policy_document.tf_kms_admin[count.index].json
# }
