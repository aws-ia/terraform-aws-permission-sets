# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

variable "templates_path" {
  description = "Specifies the path to the folder containing the permission set templates to be read by the module."
  type        = string
  default     = "./templates"
}

variable "tags" {
  description = "Specifies a map of tags to be applied to the resources created by the module."
  type        = map(string)
  default     = {}
}
