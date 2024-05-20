# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

data "aws_organizations_organization" "org" {}

data "aws_ssoadmin_instances" "sso" {}

data "aws_identitystore_group" "sso" {
  for_each          = { for group in local.ps_groups : group.Name => group }
  identity_store_id = tolist(data.aws_ssoadmin_instances.sso.identity_store_ids)[0]
  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value.Name
    }
  }
}

data "aws_identitystore_user" "sso" {
  for_each          = { for user in local.ps_users : user.Name => user }
  identity_store_id = tolist(data.aws_ssoadmin_instances.sso.identity_store_ids)[0]
  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = each.value.Name
    }
  }
}

data "aws_organizations_organizational_units" "ou" {
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

data "aws_organizations_organizational_unit_descendant_accounts" "org_accounts" {
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

data "aws_organizations_organizational_unit_descendant_accounts" "accounts_per_ou" {
  for_each  = toset(local.ps_ou_list)
  parent_id = each.key
}

data "aws_organizations_resource_tags" "account_tags" {
  for_each    = toset(local.org_accounts)
  resource_id = each.key
}
