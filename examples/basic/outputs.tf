#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

output "permission_sets" {
  value = module.aws_permission_sets.permission_sets
}

output "assignments" {
  value = module.aws_permission_sets.assignments
}
