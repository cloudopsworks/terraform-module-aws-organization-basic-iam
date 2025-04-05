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
  name               = "TerraformAccessRole"
  assume_role_policy = data.aws_iam_policy_document.terraform_access_trust.json
  description        = "Terraform Assumed Role for Resource Management"
  tags               = var.tags
}

