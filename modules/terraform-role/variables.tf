##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
variable "tags" {
  type    = map(string)
  default = {}
}

variable "account_id" {
  type = string
}

variable "trust_account_id" {
  type = string
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

variable "settings" {
  description = "Object of account settings."
  type        = any
  default     = {}
}

variable "default_terraform_user" {
  description = "Default Terraform user for the account"
  type        = string
}

variable "default_terraform_role" {
  description = "Default Terraform role for the account"
  type        = string
}

variable "secrets_manager_policy" {
  description = "Custom policy for Secrets Manager / Cross account"
  type        = any
}
