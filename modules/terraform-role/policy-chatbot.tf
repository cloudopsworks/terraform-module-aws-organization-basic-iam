# Amazon Q Developer Chatbot Admin Policy
data "aws_iam_policy_document" "tf_chatbot_admin" {
  count   = try(var.settings.awschatbot, false) ? 1 : 0
  version = "2012-10-17"
  statement {
    sid = "AmzQAllowAll"
    actions = [
      "chatbot:*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "terraform_access_chatbot_admin" {
  count  = try(var.settings.awschatbot, false) ? 1 : 0
  name   = "ChatBotAdmin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_chatbot_admin[count.index].json
}

