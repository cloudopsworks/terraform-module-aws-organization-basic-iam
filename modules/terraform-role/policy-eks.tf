# EKS Admin Policy
# EKS & ECR are combined into a single Customer Managed Policy
data "aws_iam_policy_document" "tf_eks_admin" {
  count   = try(var.settings.eks, false) ? 1 : 0
  version = "2012-10-17"
  statement {
    sid    = "EKSCreate"
    effect = "Allow"
    actions = [
      "eks:DescribeAddonConfiguration",
      "eks:ListClusters",
      "eks:DescribeAddonVersions",
      "eks:RegisterCluster",
      "eks:CreateCluster"
    ]
    resources = ["*"]
  }

  statement {
    sid     = "EKSComponents"
    effect  = "Allow"
    actions = ["eks:*"]
    resources = [
      "arn:aws:eks:*:${var.account_id}:addon/*/*/*",
      "arn:aws:eks:*:${var.account_id}:fargateprofile/*/*/*",
      "arn:aws:eks:*:${var.account_id}:cluster/*",
      "arn:aws:eks:*:${var.account_id}:identityproviderconfig/*/*/*/*",
      "arn:aws:eks:*:${var.account_id}:nodegroup/*/*/*",
      "arn:aws:eks:*:${var.account_id}:access-entry/*"
    ]
  }

  statement {
    sid    = "ECRAccess"
    effect = "Allow"
    actions = [
      "ecr:GetRegistryPolicy",
      "ecr:DescribeRegistry",
      "ecr:DescribePullThroughCacheRules",
      "ecr:DescribeRepositoryCreationTemplates",
      "ecr:GetAuthorizationToken",
      "ecr:UpdateRepositoryCreationTemplate",
      "ecr:PutRegistryScanningConfiguration",
      "ecr:CreatePullThroughCacheRule",
      "ecr:DeletePullThroughCacheRule",
      "ecr:PutRegistryPolicy",
      "ecr:GetRegistryScanningConfiguration",
      "ecr:ValidatePullThroughCacheRule",
      "ecr:CreateRepositoryCreationTemplate",
      "ecr:BatchImportUpstreamImage",
      "ecr:DeleteRepositoryCreationTemplate",
      "ecr:DeleteRegistryPolicy",
      "ecr:UpdatePullThroughCacheRule",
      "ecr:PutReplicationConfiguration",
    ]
    resources = ["*"]
  }

  statement {
    sid     = "ECRComponents"
    effect  = "Allow"
    actions = ["ecr:*"]
    resources = [
      "arn:aws:ecr:*:${var.account_id}:repository/*",
    ]
  }

  statement {
    sid       = "APSAdmin"
    effect    = "Allow"
    actions   = ["aps:*"]
    resources = ["*"]
  }

  statement {
    sid       = "Grafana"
    effect    = "Allow"
    actions   = ["grafana:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "terraform_access_eks_admin" {
  count       = try(var.settings.eks, false) ? 1 : 0
  name        = "${var.default_terraform_role}-EKSAdmin-policy"
  policy      = data.aws_iam_policy_document.tf_eks_admin[count.index].json
  description = "TerraformAccess EKS Admin Managed Policy"
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "terraform_access_eks_admin" {
  count      = try(var.settings.eks, false) ? 1 : 0
  policy_arn = aws_iam_policy.terraform_access_eks_admin[count.index].arn
  role       = aws_iam_role.terraform_access.name
}
