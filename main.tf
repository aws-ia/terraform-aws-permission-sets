# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

resource "aws_ssoadmin_permission_set" "permission_set" {
  for_each = local.ps_definition

  name             = each.value.Name
  description      = each.value.Description
  instance_arn     = local.sso_instance_arn
  session_duration = try(each.value.SessionDuration, "PT1H")
  tags             = var.tags
}

resource "aws_ssoadmin_permission_set_inline_policy" "inline_policy" {
  for_each = { for k, v in local.ps_definition : k => v if length(lookup(v, "CustomPolicy", {})) > 1 }

  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.permission_set[each.key].arn
  inline_policy      = jsonencode(each.value.CustomPolicy)
}

resource "aws_ssoadmin_managed_policy_attachment" "managed_policy" {
  for_each = local.ps_managed_policies

  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.permission_set[each.value.permission_set].arn
  managed_policy_arn = each.value.managed_policy
}

resource "aws_ssoadmin_customer_managed_policy_attachment" "customer_policy" {
  for_each = local.ps_customer_policies

  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.permission_set[each.value.permission_set].arn
  customer_managed_policy_reference {
    name = each.value.customer_policy
    path = "/"
  }
}

resource "aws_ssoadmin_permissions_boundary_attachment" "boundary" {
  for_each = { for k, v in local.ps_boundaries : k => v if v.managed_policy != "" || v.customer_policy != "" }

  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.permission_set[each.value.permission_set].arn
  permissions_boundary {
    managed_policy_arn = each.value.managed_policy == "" ? null : each.value.managed_policy
    dynamic "customer_managed_policy_reference" {
      for_each = toset(each.value.customer_policy == "" ? [] : [each.value.customer_policy])
      content {
        name = customer_managed_policy_reference.value
        path = "/"
      }
    }
  }
}

resource "aws_ssoadmin_account_assignment" "assignment" {
  for_each = { for assignment in local.assignments : "${assignment.permission_set}_${assignment.principal_id}_${assignment.principal_type}_${assignment.account_id}" => assignment }
  depends_on = [
    aws_ssoadmin_permission_set.permission_set,
    aws_ssoadmin_permission_set_inline_policy.inline_policy,
    aws_ssoadmin_managed_policy_attachment.managed_policy,
    aws_ssoadmin_customer_managed_policy_attachment.customer_policy,
    aws_ssoadmin_permissions_boundary_attachment.boundary
  ]

  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.permission_set[each.value.permission_set].arn
  principal_id       = each.value.principal_type == "GROUP" ? data.aws_identitystore_group.sso[each.value.principal_id].id : data.aws_identitystore_user.sso[each.value.principal_id].id
  principal_type     = each.value.principal_type
  target_id          = each.value.account_id
  target_type        = "AWS_ACCOUNT"
}
