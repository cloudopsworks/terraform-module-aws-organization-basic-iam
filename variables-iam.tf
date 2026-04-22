##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# account_id: "123456789012" # (Required) AWS Account ID
variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

# parent_account_id: "" # (Optional) Parent account ID. Default: ""
variable "parent_account_id" {
  description = "Parent account ID"
  type        = string
  default     = ""
}


# is_org: false # (Optional) Is this an organization-level configuration? Default: false
# is_org: false # (Optional) Is this an organization-level configuration? Default: false
variable "is_org" {
  description = "Is this an organization-level configuration"
  type        = bool
  default     = false
}

# organization_id: "o-xxxxxxxxxx" # (Optional) AWS Organization ID. Default: ""
# organization_id: "o-xxxxxxxxxx" # (Optional) AWS Organization ID. Default: ""
variable "organization_id" {
  description = "AWS Organization ID"
  type        = string
  default     = ""
}

# trust_accounts_arns: [] # (Optional) List of trust account ARNs. Default: []
# Example:
#   - "arn:aws:iam::111111111111:root"
#   - "arn:aws:iam::222222222222:root"
# trust_accounts_arns: [] # (Optional) List of trust account ARNs. Default: []
# Example:
#   - "arn:aws:iam::111111111111:root"
#   - "arn:aws:iam::222222222222:root"
variable "trust_accounts_arns" {
  description = "List of trust account ARNs"
  type        = list(string)
  default     = []
}

# default_terraform_user: "terraform-access" # (Optional) Default Terraform user for the account. Default: "terraform-access"
# default_terraform_user: "terraform-access" # (Optional) Default Terraform user for the account. Default: "terraform-access"
variable "default_terraform_user" {
  description = "Default Terraform user for the account"
  type        = string
  default     = "terraform-access"
}

# default_terraform_role: "terraform-access-role" # (Optional) Default Terraform role for the account. Default: "terraform-access-role"
# default_terraform_role: "terraform-access-role" # (Optional) Default Terraform role for the account. Default: "terraform-access-role"
variable "default_terraform_role" {
  description = "Default Terraform role for the account"
  type        = string
  default     = "terraform-access-role"
}

# secrets_manager_policy: {} # (Optional) Custom policy for Secrets Manager / Cross account. Default: {}
# Example:
#   cross_account_access: true
#   allowed_accounts:
#     - "111111111111"
variable "secrets_manager_policy" {
  description = "Custom policy for Secrets Manager / Cross account"
  type        = any
  default     = {}
}

# settings: # (Optional) Map of AWS service policy toggles. Default: {}
#   # Core Services
#   s3: false                    # (Optional) Enable S3 admin policy. Default: false
#   ec2: false                   # (Optional) Enable EC2 admin policy. Default: false
#   vpc: false                   # (Optional) Enable VPC admin policy. Default: false
#   rds: false                   # (Optional) Enable RDS admin policy. Default: false
#   lambda: false                # (Optional) Enable Lambda admin policy. Default: false
#   iam: false                   # (Optional) Enable IAM full access policy. Default: false
#   kms: false                   # (Optional) Enable KMS admin policy. Default: false
#   dynamodb: false              # (Optional) Enable DynamoDB admin policy. Default: false
#   sqs: false                   # (Optional) Enable SQS admin policy. Default: false
#   sns: false                   # (Optional) Enable SNS admin policy. Default: false
#   ses: false                   # (Optional) Enable SES admin policy. Default: false
#   ssm: false                   # (Optional) Enable SSM admin policy. Default: false
#   secrets_manager: false       # (Optional) Enable Secrets Manager admin policy. Default: false
#   # Networking
#   api_gateway: false           # (Optional) Enable API Gateway admin policy. Default: false
#   cloudfront: false            # (Optional) Enable CloudFront admin policy. Default: false
#   route53: false               # (Optional) Enable Route53 admin policy. Default: false
#   route53resolver: false       # (Optional) Enable Route53 Resolver policy. Default: false
#   acm: false                   # (Optional) Enable ACM admin policy. Default: false
#   # Security & Compliance
#   cloudtrail: false            # (Optional) Enable CloudTrail admin policy. Default: false
#   config: false                # (Optional) Enable Config admin policy. Default: false
#   guardduty: false             # (Optional) Enable GuardDuty admin policy. Default: false
#   macie2: false                # (Optional) Enable Macie2 admin policy. Default: false
#   security_hub: false          # (Optional) Enable Security Hub admin policy. Default: false
#   security_hub_org: false      # (Optional) Enable Security Hub organization admin policy. Default: false
#   detective_org: false         # (Optional) Enable Detective organization admin policy. Default: false
#   resource_explorer_org: false # (Optional) Enable Resource Explorer organization admin policy. Default: false
#   devopsguru_org: false        # (Optional) Enable DevOps Guru organization admin policy. Default: false
#   access_analyzer: false       # (Optional) Enable Access Analyzer policy. Default: false
#   nfw: false                   # (Optional) Enable Network Firewall admin policy. Default: false
#   wafv2: false                 # (Optional) Enable WAFv2 admin policy. Default: false
#   # Compute & Container
#   eks: false                   # (Optional) Enable EKS admin policy. Default: false
#   ecs: false                   # (Optional) Enable ECS admin policy. Default: false
#   elastic_beanstalk: false     # (Optional) Enable Elastic Beanstalk admin policy. Default: false
#   # Management & Monitoring
#   cloudwatch: false            # (Optional) Enable CloudWatch admin policy. Default: false
#   eventbridge: false           # (Optional) Enable EventBridge admin policy. Default: false
#   cloudformation: false        # (Optional) Enable CloudFormation admin policy. Default: false
#   sfn: false                   # (Optional) Enable Step Functions admin policy. Default: false
#   # Storage & Data
#   efs: false                   # (Optional) Enable EFS admin policy. Default: false
#   ecr: false                   # (Optional) Enable ECR admin policy. Default: false
#   # Application Services
#   cognito: false               # (Optional) Enable Cognito admin policy. Default: false
#   # Organization & Account Management
#   sso: false                   # (Optional) Enable SSO admin policy. Default: false
#   ram: false                   # (Optional) Enable RAM admin policy. Default: false
#   # AWS Services
#   awschatbot: false            # (Optional) Enable AWS Chatbot policy. Default: false
#   awsbackup: false             # (Optional) Enable AWS Backup policy. Default: false
#   device_farm: false           # (Optional) Enable Device Farm admin policy. Default: false
variable "settings" {
  description = "Map of AWS service policy toggles. Each key enables admin-level policy for that service."
  type        = any
  default     = {}
}

# allowed_pass_roles: [] # (Optional) List of ARNs that can be passed to services. Default: []
# Example:
#   - "arn:aws:iam::123456789012:role/MyServiceRole"
# allowed_pass_roles: [] # (Optional) List of ARNs that can be passed to services. Default: []
# Example:
#   - "arn:aws:iam::123456789012:role/MyServiceRole"
variable "allowed_pass_roles" {
  description = "List of ARNs that can be passed to services"
  type        = list(string)
  default     = []
}