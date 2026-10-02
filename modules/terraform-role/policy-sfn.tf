# Lambda Admin Policy
data "aws_iam_policy_document" "tf_sfn_admin" {
  count   = try(var.settings.step_functions, false) || try(var.settings.sfn, false) || try(var.settings.states, false) ? 1 : 0
  version = "2012-10-17"

  statement {
    effect    = "Allow"
    actions   = ["states:*"]
    resources = ["arn:aws:states:*:${var.account_id}:stateMachine:*"]
  }

  dynamic "statement" {
    for_each = length(var.allowed_pass_roles) > 0 ? [1] : []
    content {
      effect    = "Allow"
      actions   = ["iam:PassRole"]
      resources = var.allowed_pass_roles
    }
  }
}

resource "aws_iam_role_policy" "terraform_access_sfn_admin" {
  count  = try(var.settings.step_functions, false) || try(var.settings.sfn, false) || try(var.settings.states, false) ? 1 : 0
  name   = "StepFunctionsAdminAccess"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_sfn_admin[count.index].json
}
