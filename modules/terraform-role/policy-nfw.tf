# Network Admin Policy
data "aws_iam_policy_document" "tf_nfw_admin" {
  count   = var.is_org && try(var.settings.nfw, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    sid    = "AllowGlobal"
    effect = "Allow"
    actions = [
      "network-firewall:ListRuleGroups"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowAllObjects"
    effect = "Allow"
    actions = [
      "network-firewall:*"
    ]
    resources = [
      "arn:aws:network-firewall:*:${var.account_id}:firewall-policy/*",
      "arn:aws:network-firewall:*:${var.account_id}:stateless-rulegroup/*",
      "arn:aws:network-firewall:*:${var.account_id}:stateful-rulegroup/*",
      "arn:aws:network-firewall:*:${var.account_id}:tls-configuration/*",
      "arn:aws:network-firewall:*:${var.account_id}:firewall/*"
    ]

  }
}

# resource "aws_iam_role_policy" "terraform_access_nfw_admin" {
#   count  = var.is_org && try(var.settings.nfw, false) ? 1 : 0
#   name   = "NetworkFirewallAdmin"
#   role   = aws_iam_role.terraform_access.name
#   policy = data.aws_iam_policy_document.tf_nfw_admin[0].json
# }