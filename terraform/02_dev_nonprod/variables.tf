variable "project_id" {
  description = "Google Cloud project ID for the environment."
  type        = string
  nullable    = false
}

variable "state_bucket_name" {
  description = "Name of the GCS bucket that stores Terraform state for the environment."
  type        = string
  nullable    = false
}

variable "host_service_account_email" {
  description = "Email address of the host CI Terraform service account."
  type        = string
  default     = null
  nullable    = true
}

variable "target_service_account_email" {
  description = "Email address of the pre-provisioned target Terraform service account."
  type        = string
  nullable    = false
}

variable "target_service_account_additional_roles" {
  description = "Additional IAM roles to assign to the target Terraform service account."
  type        = list(string)
  default     = []
}
