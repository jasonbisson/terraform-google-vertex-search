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

data "google_project" "project" {
  project_id = var.project_id
}

resource "random_id" "random_suffix" {
  byte_length = 4
}

resource "google_project_service" "project_services" {
  project                    = var.project_id
  count                      = var.enable_apis ? length(var.activate_apis) : 0
  service                    = element(var.activate_apis, count.index)
  disable_on_destroy         = var.disable_services_on_destroy
  disable_dependent_services = var.disable_dependent_services
}

resource "google_project_iam_member" "discovery_service_account_iam" {
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-discoveryengine.iam.gserviceaccount.com"
}

resource "google_kms_key_ring" "key_ring" {
  project  = var.project_id
  name     = "${var.keyring}-${random_id.random_suffix.hex}"
  location = var.location
}

resource "google_kms_crypto_key" "key" {
  purpose                    = var.purpose
  name                       = "${var.key}-${random_id.random_suffix.hex}"
  key_ring                   = google_kms_key_ring.key_ring.id
  rotation_period            = var.key_rotation_period
  destroy_scheduled_duration = var.destroy_scheduled_duration

  lifecycle {
    prevent_destroy = true
  }

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }
}
