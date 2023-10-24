# terraform-google-vertex-search


### Detailed
This module will create a Customer Managed key with the required attributes for Vertex Search. The required attributes are the following

- Project must added to private preview

- Keys cannot be changed (or rotated).

- After a key has been registered, it cannot be deregistered or removed from a data store.

- You must use US or EU multi-region data stores and apps (not global ones). For more information about multi-regions and data residency, including limits associated with using non-global locations, see Vertex AI Search locations.

- Only one key per project and per organization is allowed. If you need to register keys for multiple projects, contact your Google account representative to request a quota increase for CMEK configurations, providing a justification for why you need more than one key.

The resources/services/activations/deletions that this module will create/trigger are:

- Enable required services
- Create a KMS Key Ring
- Create a KMS Key with never rotate and self service recovery 120 days
- Update CMEK Configuration for Vertex Search with a null resource


## Documentation
- [Customer Managed Encryption Keys for Vertex Search](https://cloud.google.com/generative-ai-app-builder/docs/cmek)

## Deployment Duration
Configuration: 10 mins
Deployment: 2 mins

## Usage
###
1. Clone repo
```
git clone https://github.com/jasonbisson/terraform-google-vertex-search.git
```

2. Rename and update required variables in terraform.tvfars.template
```
mv terraform.tfvars.template terraform.tfvars
#Update required variables
```

3. Execute Terraform commands with existing identity (human or service account) to build Workforce Identity Infrastructure.
```
cd ~/terraform-google-vertex-search/
terraform init
terraform plan
terraform apply
```
4. Create a new data store in Vertex Search

- Collect the Data store ID by clicking on data store name

5. Verify data store is protected with CMEK key
```
export project_id=$(terraform  output -raw project_id)
export location=$(terraform  output -raw location)
export datastore="Data store ID"

curl -X GET \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
-H "Content-Type: application/json" \
-H "x-goog-user-project: ${project_id}" \
"https://${location}-discoveryengine.googleapis.com/v1alpha/projects/${project_id}/locations/${location}/collections/default_collection/dataStores/${datastore}"

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| activate\_apis | The list of apis to activate | `list(string)` | <pre>[<br>  "iamcredentials.googleapis.com",<br>  "iam.googleapis.com",<br>  "discoveryengine.googleapis.com",<br>  "cloudkms.googleapis.com"<br>]</pre> | no |
| destroy\_scheduled\_duration | Number of days when a KMS key sits in pending destruction. This allows for self service recovery. | `string` | `"10368000s"` | no |
| disable\_dependent\_services | Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_dependent_services | `string` | `"false"` | no |
| disable\_services\_on\_destroy | Whether project services will be disabled when the resources are destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_on_destroy | `string` | `"false"` | no |
| enable\_apis | Whether to actually enable the APIs. If false, this module is a no-op. | `string` | `"true"` | no |
| key | Key name. | `string` | `"vertex-search-master-key"` | no |
| key\_algorithm | The algorithm to use when creating a version based on this template. See the https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm for possible inputs. | `string` | `"GOOGLE_SYMMETRIC_ENCRYPTION"` | no |
| key\_protection\_level | The protection level to use when creating a version based on this template. Default value: "SOFTWARE" Possible values: ["SOFTWARE", "HSM"] | `string` | `"SOFTWARE"` | no |
| key\_rotation\_period | Generate a new key every time this period passes. | `string` | `null` | no |
| keyring | Keyring name. | `string` | `"vertex-search"` | no |
| location | Location for the keyring. | `string` | `"us"` | no |
| prevent\_destroy | Set the prevent\_destroy lifecycle attribute on keys. | `bool` | `true` | no |
| project\_id | The project ID to deploy to | `string` | n/a | yes |
| purpose | The immutable purpose of the CryptoKey. Possible values are ENCRYPT\_DECRYPT, ASYMMETRIC\_SIGN, and ASYMMETRIC\_DECRYPT. | `string` | `"ENCRYPT_DECRYPT"` | no |

## Outputs

| Name | Description |
|------|-------------|
| location | Name of region |
| project\_id | Name of Google Cloud Project ID for KMS resources |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.13
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v3.0

### Deployment Identity roles

A Identity with the following roles must be used to provision
the resources of this module:

- Cloud KMS Admin: `roles/cloudkms.admin` at project level
- IAM Policy Admin: `roles/iam.securityAdmin` at project level
- Service Usage Admin: `roles/serviceusage.serviceUsageAdmin` at project level


### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- IAM: iam.googleapis.com
- Search & Chat: discoveryengine.googleapis.com
- KMS: cloudkms.googleapis.com

## Security Disclosures

Please see our [security disclosure process](./SECURITY.md).
