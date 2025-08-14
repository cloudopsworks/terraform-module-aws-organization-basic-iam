# ECS Admin Policy
# ecs & ECR are combined into a single Customer Managed Policy
data "aws_iam_policy_document" "tf_ecs_admin" {
  count   = try(var.settings.ecs, false) ? 1 : 0
  version = "2012-10-17"
  statement {
    sid    = "EcsCreate"
    effect = "Allow"
    actions = [
      "ecs:DescribeAddonConfiguration",
      "ecs:ListClusters",
      "ecs:DescribeAddonVersions",
      "ecs:RegisterCluster",
      "ecs:CreateCluster"
    ]
    resources = ["*"]
  }

  statement {
    sid     = "ECSComponents"
    effect  = "Allow"
    actions = ["ecs:*"]
    resources = [
      "arn:aws:ecs:*:${var.account_id}:*",
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
    sid = "APPAutoScaling"
    effect = "Allow"
    actions = [
      "application-autoscaling:*",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "terraform_access_ecs_admin" {
  count  = try(var.settings.ecs, false) ? 1 : 0
  role   = aws_iam_role.terraform_access.name
  name   = "ECSAdmin-policy"
  policy = data.aws_iam_policy_document.tf_ecs_admin[count.index].json
}