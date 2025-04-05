# S3 Admin Policy
data "aws_iam_policy_document" "tf_dynamodb_admin" {
  count   = try(var.settings.dynamodb, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    sid    = "AllAccessDynamoDB"
    effect = "Allow"
    actions = [
      "dynamodb:List*",
      "dynamodb:PurchaseReservedCapacityOfferings",
      "dynamodb:Describe*",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowAllOnTable"
    effect = "Allow"
    actions = [
      "dynamodb:*"
    ]
    resources = [
      "arn:aws:dynamodb:*:${var.account_id}:table/*"
    ]
  }

  statement {
    sid    = "AllowOnObjects"
    effect = "Allow"
    actions = [
      "dynamodb:*"
    ]
    resources = [
      "arn:aws:dynamodb:*:${var.account_id}:table/*/export/*",
      "arn:aws:dynamodb:*:${var.account_id}:table/*/stream/*",
      "arn:aws:dynamodb:*:${var.account_id}:table/*/import/*",
      "arn:aws:dynamodb::${var.account_id}:global-table/*",
      "arn:aws:dynamodb:*:${var.account_id}:table/*/index/*",
      "arn:aws:dynamodb:*:${var.account_id}:table/*/backup/*"
    ]
  }
}

resource "aws_iam_role_policy" "terraform_access_dynamodb_admin" {
  count  = try(var.settings.dynamodb, false) ? 1 : 0
  name   = "DynamoDBAdmin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_dynamodb_admin[count.index].json
}

