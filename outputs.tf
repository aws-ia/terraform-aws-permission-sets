# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

output "permission_sets" {
  value = { for key, value in aws_ssoadmin_permission_set.permission_set : value.name => value }
}

output "assignments" {
  value = [for k, v in aws_ssoadmin_account_assignment.assignment : v]
}
