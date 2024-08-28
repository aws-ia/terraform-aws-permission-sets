# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

output "permission_sets" {
  description = "Permission Sets definitions"
  value       = { for key, value in aws_ssoadmin_permission_set.permission_set : value.name => value }
}

output "assignments" {
  description = "Permission Sets assignments"
  value       = [for k, v in aws_ssoadmin_account_assignment.assignment : v]
}
