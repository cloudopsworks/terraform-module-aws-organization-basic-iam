# Organization Admin Policy
data "aws_iam_policy_document" "tf_organization_admin" {
  count   = var.is_org ? 1 : 0
  version = "2012-10-17"

  statement {
    sid     = "IAMServiceLinkedRole"
    effect  = "Allow"
    actions = ["iam:CreateServiceLinkedRole"]
    resources = [
      "arn:aws:iam::${var.account_id}:role/*"
    ]
  }

  statement {
    sid    = "AllowActionsAll"
    effect = "Allow"
    actions = [
      "organizations:ListRoots",
      "organizations:DisableAWSServiceAccess",
      "organizations:CreateAccount",
      "organizations:DeleteOrganization",
      "organizations:DeleteResourcePolicy",
      "organizations:ListAWSServiceAccessForOrganization",
      "organizations:ListPolicies",
      "organizations:ListHandshakesForOrganization",
      "organizations:ListDelegatedAdministrators",
      "organizations:LeaveOrganization",
      "organizations:ListHandshakesForAccount",
      "organizations:ListAccounts",
      "organizations:EnableAWSServiceAccess",
      "organizations:ListCreateAccountStatus",
      "organizations:DescribeResourcePolicy",
      "organizations:DescribeOrganization",
      "organizations:CreateGovCloudAccount",
      "organizations:EnableAllFeatures",
      "organizations:CreatePolicy",
      "organizations:DescribeCreateAccountStatus",
      "organizations:CreateOrganization"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowAllOrgObjects"
    effect = "Allow"
    actions = [
      "organizations:*"
    ]
    resources = [
      "arn:aws:organizations::${var.account_id}:handshake/${var.organization_id}/*/h-*",
      "arn:aws:organizations::${var.account_id}:account/${var.organization_id}/*",
      "arn:aws:organizations::${var.account_id}:resourcepolicy/${var.organization_id}/rp-*",
      "arn:aws:organizations::${var.account_id}:root/${var.organization_id}/r-*",
      "arn:aws:organizations::${var.account_id}:policy/${var.organization_id}/*/p-*",
      "arn:aws:organizations::${var.account_id}:ou/${var.organization_id}/ou-*"
    ]

  }
}

resource "aws_iam_role_policy" "terraform_access_organization_admin" {
  count  = var.is_org ? 1 : 0
  name   = "OrganizationAdmin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_organization_admin[0].json
}