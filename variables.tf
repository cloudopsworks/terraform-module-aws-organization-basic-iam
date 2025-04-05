##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

variable "org" {
  type = object({
    organization_name = string
    organization_unit = string
    environment_type  = string
    environment_name  = string
  })
}

variable "account_id" {
  type = string
}

variable "parent_account_id" {
  type    = string
  default = ""
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}

variable "is_org" {
  type    = bool
  default = false
}

variable "organization_id" {
  type    = string
  default = ""
}

variable "trust_accounts_arns" {
  description = "List of trust account ARNs"
  type        = list(string)
  default     = []
}

variable "default_terraform_user" {
  description = "Default Terraform user for the account"
  type        = string
  default     = "terraform-access"
}

variable "default_terraform_role" {
  description = "Default Terraform role for the account"
  type        = string
  default     = "TerraformAccessRole"
}

## YAML Sample
# settings:
#   s3: true | false # Defaults to false
#   api_gateway: true | false # Defaults to false
#   cognito: true | false # Defaults to false
#   ec2: true | false # Defaults to false
#   rds: true | false # Defaults to false
#   vpc: true | false # Defaults to false
#   acm: true | false # Defaults to false
#   sso: true | false # Defaults to false
#   ssm: true | false # Defaults to false
#   sqs: true | false # Defaults to false
#   sns: true | false # Defaults to false
#   ses: true | false # Defaults to false
#   lambda: true | false # Defaults to false
#   secrets_manager: true | false # Defaults to false
#   iam: true | false # Defaults to false
#   cloudwatch: true | false # Defaults to false
#   eks: true | false # Defaults to false
#   ram: true | false # Defaults to false
#   route53: true | false # Defaults to false
#   kms: true | false # Defaults to false
#   iam: true | false # Defaults to false
#   eventbridge: true | false # Defaults to false
#   elastic_beanstalk: true | false # Defaults to false
#   dynamodb: true | false # Defaults to false
#   cloudfront: true | false # Defaults to false
#   awschatbot: true | false # Defaults to false
#   awsbackup: true | false # Defaults to false
variable "settings" {
  description = "Map for policy settings"
  type        = any
  default     = {}
}