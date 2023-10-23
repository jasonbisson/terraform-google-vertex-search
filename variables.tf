/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "enable_apis" {
  description = "Whether to actually enable the APIs. If false, this module is a no-op."
  default     = "true"
}

variable "activate_apis" {
  description = "The list of apis to activate"
  default     = ["iamcredentials.googleapis.com", "iam.googleapis.com", "discoveryengine.googleapis.com", "cloudkms.googleapis.com"]
  type        = list(string)
}

variable "disable_services_on_destroy" {
  description = "Whether project services will be disabled when the resources are destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_on_destroy"
  default     = "false"
  type        = string
}

variable "disable_dependent_services" {
  description = "Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_dependent_services"
  default     = "false"
  type        = string
}

variable "location" {
  description = "Location for the keyring."
  type        = string
  default     = "us"
}

variable "keyring" {
  description = "Keyring name."
  type        = string
  default     = "vertex-search"
}

variable "key" {
  description = "Key name."
  type        = string
  default     = "vertex-search-master-key"
}

variable "prevent_destroy" {
  description = "Set the prevent_destroy lifecycle attribute on keys."
  type        = bool
  default     = true
}

variable "purpose" {
  type        = string
  description = "The immutable purpose of the CryptoKey. Possible values are ENCRYPT_DECRYPT, ASYMMETRIC_SIGN, and ASYMMETRIC_DECRYPT."
  default     = "ENCRYPT_DECRYPT"
}


variable "key_rotation_period" {
  description = "Generate a new key every time this period passes."
  type        = string
  default     = null
}

variable "key_algorithm" {
  type        = string
  description = "The algorithm to use when creating a version based on this template. See the https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm for possible inputs."
  default     = "GOOGLE_SYMMETRIC_ENCRYPTION"
}

variable "key_protection_level" {
  type        = string
  description = "The protection level to use when creating a version based on this template. Default value: \"SOFTWARE\" Possible values: [\"SOFTWARE\", \"HSM\"]"
  default     = "SOFTWARE"
}

variable "destroy_scheduled_duration" {
  type        = string
  description = "Number of days when a KMS key sits in pending destruction. This allows for self service recovery."
  default     = "10368000s"
}
