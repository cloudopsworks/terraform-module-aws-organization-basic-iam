# AWS Config Policy
data "aws_iam_policy_document" "tf_devicefarm_admin" {
  count   = try(var.settings.device_farm, var.settings.devicefarm, false) ? 1 : 0
  version = "2012-10-17"
  statement {
    sid = "DeviceFarmConfigAllowAll"
    actions = [
      "devicefarm:*",
    ]

    resources = [
      "*",
    ]
  }
}