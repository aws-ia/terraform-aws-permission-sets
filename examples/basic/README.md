<!-- BEGIN_TF_DOCS -->
# Managing Permission Sets using Terraform

This example shows how you can use this module to create and manage IAM Identity Center Permissions Sets for multiple AWS Accounts within an AWS Organizations. The code will create tww sample Permission Sets and assign them to all accounts.

Note: We are assuming that you already have an IAM Identity Center set up and enabled across the organization. See [Enabling AWS IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/get-set-up-for-idc.html) documentation.

1. Open the folder **templates** and check the two files there: **ps-cloudops-sample.json** and **ps-viewonly-sample.json**
2. Make sure that both groups specified as \_principal\_, "AuditorsGroup" and "CloudOpsGroup", have been created in your IAM Identity Center directory. Or replace the values with your own groups.
3. Run: `terraform init` and then `terraform apply`
4. That should create both Permissions Sets based on the templates, listed all accounts in the AWS Organizations and assign the Permission Sets with them.

We recommend to use an IAM Identity Center delegated account to manage Permissions Sets. See [Delegated administration](https://docs.aws.amazon.com/singlesignon/latest/userguide/delegated-admin.html) for more.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_permission_sets"></a> [aws\_permission\_sets](#module\_aws\_permission\_sets) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_templates_path"></a> [templates\_path](#input\_templates\_path) | n/a | `string` | `"./templates"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_assignments"></a> [assignments](#output\_assignments) | n/a |
| <a name="output_permission_sets"></a> [permission\_sets](#output\_permission\_sets) | n/a |
<!-- END_TF_DOCS -->