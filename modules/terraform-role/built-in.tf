##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
## -- Built In Policies

data "aws_iam_policy" "apig_admin" {
  count = try(var.settings.api_gateway, false) ? 1 : 0
  name  = "AmazonAPIGatewayAdministrator"
}

data "aws_iam_policy" "cognito_power_user" {
  count = try(var.settings.cognito, false) ? 1 : 0
  name  = "AmazonCognitoPowerUser"
}

data "aws_iam_policy" "ec2_full" {
  count = try(var.settings.ec2, false) ? 1 : 0
  name  = "AmazonEC2FullAccess"
}

data "aws_iam_policy" "rds_full" {
  count = try(var.settings.rds, false) ? 1 : 0
  name  = "AmazonRDSFullAccess"
}

data "aws_iam_policy" "vpc_full" {
  count = try(var.settings.vpc, false) ? 1 : 0
  name  = "AmazonVPCFullAccess"
}

data "aws_iam_policy" "acm_full" {
  count = try(var.settings.acm, false) ? 1 : 0
  name  = "AWSCertificateManagerFullAccess"
}

resource "aws_iam_role_policy_attachment" "tf_apig_admin" {
  count      = try(var.settings.api_gateway, false) ? 1 : 0
  role       = aws_iam_role.terraform_access.name
  policy_arn = data.aws_iam_policy.apig_admin[count.index].arn
}

resource "aws_iam_role_policy_attachment" "tf_cognito" {
  count      = try(var.settings.cognito, false) ? 1 : 0
  role       = aws_iam_role.terraform_access.name
  policy_arn = data.aws_iam_policy.cognito_power_user[count.index].arn
}

resource "aws_iam_role_policy_attachment" "tf_ec2_full" {
  count      = try(var.settings.ec2, false) ? 1 : 0
  role       = aws_iam_role.terraform_access.name
  policy_arn = data.aws_iam_policy.ec2_full[count.index].arn
}

resource "aws_iam_role_policy_attachment" "tf_rds_full" {
  count      = try(var.settings.rds, false) ? 1 : 0
  role       = aws_iam_role.terraform_access.name
  policy_arn = data.aws_iam_policy.rds_full[count.index].arn
}

resource "aws_iam_role_policy_attachment" "tf_vpc_full" {
  count      = try(var.settings.vpc, false) ? 1 : 0
  role       = aws_iam_role.terraform_access.name
  policy_arn = data.aws_iam_policy.vpc_full[count.index].arn
}

resource "aws_iam_role_policy_attachment" "tf_acm_full" {
  count      = try(var.settings.acm, false) ? 1 : 0
  role       = aws_iam_role.terraform_access.name
  policy_arn = data.aws_iam_policy.acm_full[count.index].arn
}
