##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
output "role_arn" {
  value = aws_iam_role.terraform_access.arn

  precondition {
    condition     = local.inline_policies_size <= local.inline_policies_size_limit
    error_message = "Inline policies of the terraform role total ${local.inline_policies_size} characters, above the ${local.inline_policies_size_limit} IAM quota. Compact the inline policy documents or move one to a managed policy."
  }

  precondition {
    condition     = local.managed_policies_count <= local.managed_policies_quota
    error_message = "The terraform role would get ${local.managed_policies_count} managed policies, above the quota of ${local.managed_policies_quota}. Disable a managed-policy setting, or raise the IAM \"Managed policies per role\" Service Quota and set settings.managed_policies_quota to match."
  }

  precondition {
    condition     = length(local.oversized_managed_policies) == 0
    error_message = "Managed policies above the ${local.managed_policy_size_limit} character IAM quota: ${jsonencode(local.oversized_managed_policies)}."
  }
}