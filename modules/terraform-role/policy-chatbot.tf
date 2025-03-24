# SES Admin Policy
data "aws_iam_policy_document" "tf_chatbot_admin" {
  version = "2012-10-17"
  statement {
    sid = "AllowRead"
    actions = [
      "chatbot:*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "terraform_access_chatbot_admin" {
  name   = "ChatBotAdmin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_chatbot_admin.json
}

