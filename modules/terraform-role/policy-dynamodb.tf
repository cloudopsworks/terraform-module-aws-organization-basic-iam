# S3 Admin Policy
data "aws_iam_policy_document" "tf_dynamodb_admin" {
  count   = try(var.settings.dynamodb, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:List*",
      "dynamodb:PurchaseReservedCapacityOfferings",
      "dynamodb:Describe*",
    ]
    resources = ["*"]
  }

  # table/* also matches the index, stream, backup, export and import sub-resources.
  statement {
    effect  = "Allow"
    actions = ["dynamodb:*"]
    resources = [
      "arn:aws:dynamodb:*:${var.account_id}:table/*",
      "arn:aws:dynamodb::${var.account_id}:global-table/*",
    ]
  }
}

resource "aws_iam_role_policy" "terraform_access_dynamodb_admin" {
  count  = try(var.settings.dynamodb, false) ? 1 : 0
  name   = "DynamoDBAdmin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_dynamodb_admin[count.index].json
}

