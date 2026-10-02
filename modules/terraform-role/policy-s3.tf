# S3 Admin Policy
data "aws_iam_policy_document" "tf_s3_admin" {
  count   = try(var.settings.s3, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "s3:ListStorageLensConfigurations",
      "s3:ListAccessPointsForObjectLambda",
      "s3:GetAccessPoint",
      "s3:PutAccountPublicAccessBlock",
      "s3:GetAccountPublicAccessBlock",
      "s3:ListAllMyBuckets",
      "s3:ListAccessPoints",
      "s3:PutAccessPointPublicAccessBlock",
      "s3:ListJobs",
      "s3:PutStorageLensConfiguration",
      "s3:ListMultiRegionAccessPoints",
      "s3:CreateJob",
    ]
    resources = ["*"]
  }

  # arn:aws:s3:::* also matches every object ARN (arn:aws:s3:::bucket/key).
  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::*",
      "arn:aws:s3::${var.account_id}:accesspoint/*",
      "arn:aws:s3:*:${var.account_id}:storage-lens/*",
      "arn:aws:s3:*:${var.account_id}:accesspoint/*",
      "arn:aws:s3-object-lambda:*:${var.account_id}:accesspoint/*",
      "arn:aws:s3:*:${var.account_id}:job/*",
      "arn:aws:s3:*:${var.account_id}:async-request/mrap/*/*",
    ]
  }
}

resource "aws_iam_role_policy" "terraform_access_s3_admin" {
  count  = try(var.settings.s3, false) ? 1 : 0
  name   = "S3Admin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_s3_admin[count.index].json
}
