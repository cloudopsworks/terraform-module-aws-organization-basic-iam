# Cloudfront Admin Role
data "aws_iam_policy_document" "tf_cloudfront_admin" {
  count   = try(var.settings.cloudfront, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    sid    = "CloudfrontAdmin"
    effect = "Allow"
    actions = [
      "cloudfront:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "terraform_access_cloudfront_admin" {
  count  = try(var.settings.cloudfront, false) ? 1 : 0
  name   = "CloudFrontAdmin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_cloudfront_admin[count.index].json
}
