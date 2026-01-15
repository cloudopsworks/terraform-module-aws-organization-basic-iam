# Elastic Beanstalk Admin
resource "aws_iam_role_policy_attachment" "beanstalk_admin" {
  count      = try(var.settings.elastic_beanstalk, var.settings.elasticbeanstalk, var.settings.beanstalk, false) ? 1 : 0
  role       = aws_iam_role.terraform_access.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess-AWSElasticBeanstalk"
}