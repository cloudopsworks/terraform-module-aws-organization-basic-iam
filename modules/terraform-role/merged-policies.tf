##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  sensitive_policies = concat(
    try(var.settings.kms, false) ? [data.aws_iam_policy_document.tf_kms_admin[0].json] : [],
    try(var.settings.macie2, false) ? [data.aws_iam_policy_document.tf_macie2_admin[0].json] : [],
    try(var.settings.awsconfig, false) ? [data.aws_iam_policy_document.tf_config_admin[0].json] : [],
    var.is_org && try(var.settings.nfw, false) ? [data.aws_iam_policy_document.tf_nfw_admin[0].json] : [],
    try(var.settings.ram, false) ? [data.aws_iam_policy_document.tf_ram_policy_admin[0].json] : [],
    try(var.settings.security_hub, false) ? [data.aws_iam_policy_document.tf_securityhub_admin[0].json] : [],
    try(var.settings.secrets_manager, false) ? [data.aws_iam_policy_document.tf_secrets_admin[0].json, data.aws_iam_policy_document.tf_secrets_reader[0].json] : [],
    length(var.secrets_manager_policy) > 0 ? [data.aws_iam_policy_document.secrets_cross_account[0].json] : [],
    try(var.settings.iam, false) ? [data.aws_iam_policy_document.tf_iam_full[0].json] : [],
    try(var.settings.cloudtrail, false) ? [data.aws_iam_policy_document.tf_cloudtrail_admin[0].json] : [],
    try(var.settings.security_hub_org, false) ? [data.aws_iam_policy.security_hub_organization_admin[0].policy] : [],
    try(var.settings.detective_org, false) ? [data.aws_iam_policy.detective_organization_admin[0].policy] : [],
    try(var.settings.resource_explorer_org, false) ? [data.aws_iam_policy.resource_explorer_organization_admin[0].policy] : [],
    try(var.settings.devopsguru_org, false) ? [data.aws_iam_policy.devopsguru_organization_admin[0].policy] : [],
    try(var.settings.guard_duty, false) ? [data.aws_iam_policy_document.tf_guardduty_admin[0].json] : []
  )
}

data "aws_iam_policy_document" "terraform_access_sensitive_combined" {
  count                   = length(local.sensitive_policies) > 0 ? 1 : 0
  source_policy_documents = local.sensitive_policies
}