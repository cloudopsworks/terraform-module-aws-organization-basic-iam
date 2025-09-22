# Route53 Admin Policy
data "aws_iam_policy_document" "tf_route53_admin" {
  count   = try(var.settings.route53, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    sid    = "Route53ReadWriteAll"
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:CreateCidrCollection",
      "route53:CreateHealthCheck",
      "route53:CreateHostedZone",
      "route53:CreateReusableDelegationSet",
      "route53:CreateTrafficPolicy",
      "route53:Get*",
      "route53:List*",
      "route53:TestDNSAnswer",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Route53ResourceAdmin"
    effect = "Allow"
    actions = [
      "route53:AssociateVPCWithHostedZone",
      "route53:ChangeTagsForResource",
      "route53:CreateQueryLoggingConfig",
      "route53:CreateTagsForResource",
      "route53:CreateTrafficPolicyInstance",
      "route53:DeleteCidrCollection",
      "route53:DeleteHealthCheck",
      "route53:DeleteHostedZone",
      "route53:DeleteQueryLoggingConfig",
      "route53:DeleteReusableDelegationSet",
      "route53:DeleteTagsForResource",
      "route53:DeleteTrafficPolicy",
      "route53:DeleteTrafficPolicyInstance",
      "route53:DisassociateVPCFromHostedZone",
      "route53:ListTagsForResource",
      "route53:TagResource",
      "route53:UntagResource",
      "route53:UpdateCidrCollection",
      "route53:UpdateHealthCheck",
      "route53:UpdateHostedZoneComment",
      "route53:UpdateQueryLoggingConfig",
      "route53:UpdateTrafficPolicyComment",
      "route53:UpdateTrafficPolicyInstance",
    ]
    resources = [
      "arn:aws:route53:::hostedzone/*",
      "arn:aws:route53:::trafficpolicyinstance/*",
      "arn:aws:route53:::healthcheck/*",
      "arn:aws:route53:::change/*",
      "arn:aws:route53:::trafficpolicy/*",
      "arn:aws:route53:::cidrcollection/*",
      "arn:aws:route53:::queryloggingconfig/*",
      "arn:aws:route53:::delegationset/*"
    ]
  }

  statement {
    sid    = "Route53ResolverAll"
    effect = "Allow"
    actions = [
      "route53resolver:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "terraform_access_route53_admin" {
  count  = try(var.settings.route53, false) ? 1 : 0
  name   = "${var.default_terraform_role}-Route53-policy"
  policy = data.aws_iam_policy_document.tf_route53_admin[count.index].json
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "terraform_access_route53_admin" {
  count      = try(var.settings.route53, false) ? 1 : 0
  policy_arn = aws_iam_policy.terraform_access_route53_admin[count.index].arn
  role       = aws_iam_role.terraform_access.name
}
