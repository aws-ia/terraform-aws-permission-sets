#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

module "aws_permission_sets" {
  # source = "git@github.com:aws-ia/terraform-aws-permission-sets.git"
  source = "../.."

  templates_path = "./templates"
  tags           = var.tags
}
