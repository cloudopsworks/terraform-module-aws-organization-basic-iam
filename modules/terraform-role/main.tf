##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
data "aws_iam_policy_document" "terraform_access_trust" {
  version = "2012-10-17"
  statement {
    sid     = "Statement1"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = concat([
        "arn:aws:iam::${var.trust_account_id}:user/${var.default_terraform_user}",
        ],
      var.trust_accounts_arns)
    }
  }
}

resource "aws_iam_role" "terraform_access" {
  name               = var.default_terraform_role
  assume_role_policy = data.aws_iam_policy_document.terraform_access_trust.json
  description        = "Terraform Assumed Role for Resource Management"
  tags               = var.tags
}

resource "aws_iam_policy" "terraform_access_sentsitive" {
  count       = length(local.sensitive_policies) > 0 ? 1 : 0
  name        = format("%s-sentsitive-policy", var.default_terraform_role)
  description = "Terraform Access Policy for Resource Management"
  policy      = data.aws_iam_policy_document.terraform_access_sensitive_combined[0].minified_json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "terraform_access" {
  count      = length(local.sensitive_policies) > 0 ? 1 : 0
  role       = aws_iam_role.terraform_access.name
  policy_arn = aws_iam_policy.terraform_access_sentsitive[0].arn
}
