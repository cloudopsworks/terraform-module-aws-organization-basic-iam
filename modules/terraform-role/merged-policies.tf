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
    try(var.settings.secrets_manager, var.settings.secretsmanager, false) ? [data.aws_iam_policy_document.tf_secrets_admin[0].json, data.aws_iam_policy_document.tf_secrets_reader[0].json] : [],
    length(var.secrets_manager_policy) > 0 ? [data.aws_iam_policy_document.secrets_cross_account[0].json] : [],
    try(var.settings.iam, false) ? [data.aws_iam_policy_document.tf_iam_full[0].json] : [],
    try(var.settings.cloudtrail, false) ? [data.aws_iam_policy_document.tf_cloudtrail_admin[0].json] : [],
    try(var.settings.security_hub_org, false) ? [data.aws_iam_policy.security_hub_organization_admin[0].policy] : [],
    try(var.settings.detective_org, false) ? [data.aws_iam_policy.detective_organization_admin[0].policy] : [],
    try(var.settings.resource_explorer_org, false) ? [data.aws_iam_policy.resource_explorer_organization_admin[0].policy] : [],
    try(var.settings.devopsguru_org, false) ? [data.aws_iam_policy.devopsguru_organization_admin[0].policy] : [],
    try(var.settings.guard_duty, false) ? [data.aws_iam_policy_document.tf_guardduty_admin[0].json] : [],
    try(var.settings.access_analyzer, false) ? [data.aws_iam_policy_document.tf_access_analyzer[0].json] : [],
    try(var.settings.device_farm, var.settings.devicefarm, false) ? [data.aws_iam_policy_document.tf_devicefarm_admin[0].json] : [],
    try(var.settings.wafv2, var.settings.waf, var.settings.waf_v2, false) ? [data.aws_iam_policy_document.tf_wafv2_admin[0].json] : [],
  )
}

data "aws_iam_policy_document" "terraform_access_sensitive_combined" {
  count                   = length(local.sensitive_policies) > 0 ? 1 : 0
  source_policy_documents = local.sensitive_policies
}
# IAM caps the aggregate size of all inline policies of a role at 10,240 characters,
# not counting white space. Every aws_iam_role_policy of this module must be listed
# here so the role_arn output precondition fails the plan before the apply does.
locals {
  inline_policies_size_limit = 10240
  inline_policies_size = sum([for policy in concat(
    aws_iam_role_policy.terraform_access_backup_admin[*].policy,
    aws_iam_role_policy.terraform_access_chatbot_admin[*].policy,
    aws_iam_role_policy.terraform_access_cloudtransformation_admin[*].policy,
    aws_iam_role_policy.terraform_access_cloudfront_admin[*].policy,
    aws_iam_role_policy.terraform_access_cloudwatch_admin[*].policy,
    aws_iam_role_policy.terraform_access_dynamodb_admin[*].policy,
    aws_iam_role_policy.terraform_access_ecs_admin[*].policy,
    aws_iam_role_policy.terraform_access_efs_admin[*].policy,
    aws_iam_role_policy.terraform_access_eventbridge_admin[*].policy,
    aws_iam_role_policy.terraform_access_lambda_admin[*].policy,
    aws_iam_role_policy.terraform_access_organization_admin[*].policy,
    aws_iam_role_policy.terraform_access_s3_admin[*].policy,
    aws_iam_role_policy.terraform_access_ses_admin[*].policy,
    aws_iam_role_policy.terraform_access_sfn_admin[*].policy,
    aws_iam_role_policy.terraform_access_sns_admin[*].policy,
    aws_iam_role_policy.terraform_access_sqs_admin[*].policy,
    aws_iam_role_policy.terraform_access_ssm_store[*].policy,
    aws_iam_role_policy.terraform_access_sso_admin[*].policy,
    [""],
  ) : length(replace(policy, "/\\s/", ""))])
}

# IAM caps managed policy attachments per role (10 by default, adjustable up to 20
# through Service Quotas) and each customer managed policy at 6,144 characters, not
# counting white space. Every aws_iam_role_policy_attachment and aws_iam_policy of this
# module must be listed here so the role_arn output preconditions fail the plan.
locals {
  managed_policies_quota = try(var.settings.managed_policies_quota, 10)
  managed_policies_count = length(concat(
    aws_iam_role_policy_attachment.terraform_access[*].policy_arn,
    aws_iam_role_policy_attachment.terraform_access_eks_admin[*].policy_arn,
    aws_iam_role_policy_attachment.terraform_access_route53_admin[*].policy_arn,
    aws_iam_role_policy_attachment.beanstalk_admin[*].policy_arn,
    aws_iam_role_policy_attachment.tf_apig_admin[*].policy_arn,
    aws_iam_role_policy_attachment.tf_cognito[*].policy_arn,
    aws_iam_role_policy_attachment.tf_ec2_full[*].policy_arn,
    aws_iam_role_policy_attachment.tf_rds_full[*].policy_arn,
    aws_iam_role_policy_attachment.tf_vpc_full[*].policy_arn,
    aws_iam_role_policy_attachment.tf_acm_full[*].policy_arn,
  ))
  managed_policy_size_limit = 6144
  oversized_managed_policies = {
    for policy in concat(
      aws_iam_policy.terraform_access_sentsitive,
      aws_iam_policy.terraform_access_eks_admin,
      aws_iam_policy.terraform_access_route53_admin,
    ) : policy.name => length(replace(policy.policy, "/\\s/", ""))
    if length(replace(policy.policy, "/\\s/", "")) > local.managed_policy_size_limit
  }
}
