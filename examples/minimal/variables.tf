variable "project_id" {
  description = "Google Cloud project ID for the sandbox environment."
  type        = string
  nullable    = false
}

variable "org_id" {
  description = "Numeric Google Cloud organisation ID."
  type        = string
  nullable    = false
}

variable "target_service_account_email" {
  description = "Email of the CI service account that will request JIT grants."
  type        = string
  nullable    = false
}
