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

resource "null_resource" "update_cmek_config" {
  provisioner "local-exec" {
    command = <<EOF
curl -X patch \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
-H "Content-Type: application/json" \
-d '{"kms_key":"${google_kms_key_ring.key_ring.id}/cryptoKeys/${google_kms_crypto_key.key.name}"}' \
"https://${var.location}-discoveryengine.googleapis.com/v1alpha/projects/${var.project_id}/locations/${var.location}/cmekConfig"
EOF
  }
}
