<!-- BEGIN_TF_DOCS -->
# AWS Permissions Sets

Use this module to dynamic manage AWS IAM Identity Center Permission Sets using Terraform and JSON file templates.

## Prerequisites

Ensure that you have an instance of IAM Identity Center set up and enabled across your organization. For detailed guidance, refer to the [Enabling AWS IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/get-set-up-for-idc.html) documentation. It is highly recommended to use an IAM Identity Center administrator delegated account for managing Permission Sets. For more information, see [Delegated administration](https://docs.aws.amazon.com/singlesignon/latest/userguide/delegated-admin.html).

1. AWS account and credentials
2. Terraform set up
3. JSON file templates

## JSON file templates

Create a folder to store your JSON file templates, which will include the Permission Set definitions (name, policies, assignments, etc.). When using this module, make sure to specify the path to this folder in the `templates_path` variable.

See the JSON schema for Permission Set templates:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "Name": {
      "type": "string"
    },
    "Comment": {
      "type": "string"
    },
    "Description": {
      "type": "string"
    },
    "SessionDuration": {
      "type": "string"
    },
    "ManagedPolicies": {
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "CustomerPolicies": {
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "CustomPolicy": {
      "type": "object",
      "properties": {
        "items": {
          "type": "string"
        }
      }
    },
    "PermissionBoundary": {
      "type": "object",
      "properties": {
        "ManagedPolicy": {
          "type": "string"
        },
        "CustomerPolicy": {
          "type": "string"
        }
      }
    },
    "Tags": {
      "type": "object",
      "properties": {
        "Teams": {
          "type": "string"
        }
      }
    },
    "Assignments": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "all_accounts": {
            "type": "boolean"
          },
          "principal": {
            "type": "string"
          },
          "type": {
            "type": "string",
            "enum": ["GROUP", "USER"]
          },
          "account_id": {
            "type": "array",
            "items": {
              "type": "string"
            }
          },
          "account_ou": {
            "type": "array",
            "items": {
              "type": "string"
            }
          },
          "account_tag": {
            "type": "object",
            "items": {
              "type": "string"
            }
          }
        },
        "required": ["all_accounts", "principal", "type"]
      }
    }
  },
  "anyOf": [
    {
      "required": [
        "Name",
        "Comment",
        "Description",
        "SessionDuration",
        "ManagedPolicies",
        "PermissionBoundary",
        "Assignments"
      ]
    },
    {
      "required": [
        "Name",
        "Comment",
        "Description",
        "SessionDuration",
        "CustomerPolicies",
        "PermissionBoundary",
        "Assignments"
      ]
    },
    {
      "required": [
        "Name",
        "Comment",
        "Description",
        "SessionDuration",
        "CustomPolicy",
        "PermissionBoundary",
        "Assignments"
      ]
    }
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssoadmin_account_assignment.assignment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_customer_managed_policy_attachment.customer_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_customer_managed_policy_attachment) | resource |
| [aws_ssoadmin_managed_policy_attachment.managed_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_managed_policy_attachment) | resource |
| [aws_ssoadmin_permission_set.permission_set](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set) | resource |
| [aws_ssoadmin_permission_set_inline_policy.inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set_inline_policy) | resource |
| [aws_ssoadmin_permissions_boundary_attachment.boundary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permissions_boundary_attachment) | resource |
| [aws_identitystore_group.sso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_group) | data source |
| [aws_identitystore_user.sso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_user) | data source |
| [aws_organizations_organization.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_organizations_organizational_unit_descendant_accounts.accounts_per_ou](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_unit_descendant_accounts) | data source |
| [aws_organizations_organizational_unit_descendant_accounts.org_accounts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_unit_descendant_accounts) | data source |
| [aws_organizations_resource_tags.account_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_resource_tags) | data source |
| [aws_ssoadmin_instances.sso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags) | Specifies a map of tags to be applied to the resources created by the module. | `map(string)` | `{}` | no |
| <a name="input_templates_path"></a> [templates\_path](#input\_templates\_path) | Specifies the path to the folder containing the permission set templates to be read by the module. | `string` | `"./templates"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_assignments"></a> [assignments](#output\_assignments) | Permission Sets assignments |
| <a name="output_permission_sets"></a> [permission\_sets](#output\_permission\_sets) | Permission Sets definitions |
<!-- END_TF_DOCS -->