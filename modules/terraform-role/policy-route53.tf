# Route53 Admin Policy
data "aws_iam_policy_document" "tf_route53_admin" {
  count   = try(var.settings.route53, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    sid    = "Route53ReadAll"
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:CreateCidrCollection",
      "route53:CreateHealthCheck",
      "route53:CreateHostedZone",
      "route53:CreateReusableDelegationSet",
      "route53:CreateTrafficPolicy",
      "route53:GetAccountLimit",
      "route53:GetCheckerIpRanges",
      "route53:GetGeoLocation",
      "route53:GetHealthCheckCount",
      "route53:GetHostedZoneCount",
      "route53:GetTrafficPolicyInstanceCount",
      "route53:ListCidrCollections",
      "route53:ListGeoLocations",
      "route53:ListHealthChecks",
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName",
      "route53:ListHostedZonesByVPC",
      "route53:ListResourceRecordSets",
      "route53:ListReusableDelegationSets",
      "route53:ListTrafficPolicies",
      "route53:ListTrafficPolicyInstances",
      "route53:TestDNSAnswer",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Route53ResourceAdmin"
    effect = "Allow"
    actions = [
      "route53:*"
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
}

resource "aws_iam_role_policy_attachment" "terraform_access_route53_admin" {
  count      = try(var.settings.route53, false) ? 1 : 0
  policy_arn = aws_iam_policy.terraform_access_route53_admin[count.index].arn
  role       = aws_iam_role.terraform_access.name
}
