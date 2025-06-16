# AWS Backup Policy
data "aws_iam_policy_document" "tf_backup_admin" {
  count   = try(var.settings.awsbackup, false) ? 1 : 0
  version = "2012-10-17"
  statement {
    sid = "BackupAllowAll"
    actions = [
      "backup:*",
      "backup-storage:*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "terraform_access_backup_admin" {
  count  = try(var.settings.awsbackup, false) ? 1 : 0
  name   = "BackupAdmin"
  role   = aws_iam_role.terraform_access.name
  policy = data.aws_iam_policy_document.tf_backup_admin[count.index].json
}

