variable "project_id" {
  description = "Google Cloud project ID for the environment."
  type        = string
  nullable    = false
}

variable "org_id" {
  description = "Numeric Google Cloud organisation ID. Used to construct the PAM service agent identity."
  type        = string
  nullable    = false
  validation {
    condition     = can(regex("^[0-9]+$", var.org_id))
    error_message = "org_id must contain only numbers"
  }
}

variable "target_service_account_email" {
  description = "Email address of the target Terraform service account. This SA will be the eligible requester for JIT grants."
  type        = string
  nullable    = false
  validation {
    condition     = can(regex("^[^@]+@[^@]+\\.iam\\.gserviceaccount\\.com$", var.target_service_account_email))
    error_message = "target_service_account_email must be a valid service account email ending in .iam.gserviceaccount.com"
  }
}

variable "target_sa_pam_grants_role_id" {
  description = "Role ID for the project-level custom IAM role granting PAM grant request, read, and revoke operations to the target service account."
  type        = string
  default     = "pamGrantsManager"
  validation {
    condition     = can(regex("^[a-zA-Z0-9_]{3,64}$", var.target_sa_pam_grants_role_id))
    error_message = "target_sa_pam_grants_role_id must be 3-64 characters using letters, numbers, or underscore."
  }
}

variable "ci_pam_entitlement_id" {
  description = "ID for the PAM entitlement. Must be unique within the project location."
  type        = string
  default     = "ci-terraform-apply"
}

variable "ci_pam_elevated_roles" {
  description = "IAM roles to make available via JIT elevation. These are the write/admin roles removed from permanent assignment on the target service account."
  type        = list(string)
  nullable    = false
  validation {
    condition     = length(var.ci_pam_elevated_roles) > 0
    error_message = "ci_pam_elevated_roles must contain at least one IAM role."
  }
  validation {
    condition     = alltrue([for r in var.ci_pam_elevated_roles : can(regex("^roles/", r))])
    error_message = "Each entry in ci_pam_elevated_roles must be a predefined role beginning with 'roles/'."
  }
}

variable "ci_pam_approver_principals" {
  description = "Google identity principals authorised to approve PAM grants (e.g. 'user:engineer@example.gov.uk', 'group:platform-team@example.gov.uk'). An empty list enables auto-approval; suitable for sandbox environments only."
  type        = list(string)
  default     = []
}

variable "ci_pam_admin_notification_email_recipients" {
  description = "Additional email recipients to notify when PAM grants are approved and activated. Use for central mailbox routing (e.g. 'pam-alerts@example.gov.uk')."
  type        = list(string)
  nullable    = false
  default     = []
  validation {
    condition = alltrue([
      for addr in var.ci_pam_admin_notification_email_recipients :
      can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", addr))
    ])
    error_message = "Each entry in ci_pam_admin_notification_email_recipients must be a valid email address."
  }
}

variable "ci_pam_max_grant_duration" {
  description = "Maximum duration for a PAM grant in seconds notation (e.g. '7200s'). Should cover the worst-case apply runtime; the grant is revoked programmatically on build completion."
  type        = string
  default     = "7200s"
  validation {
    condition     = can(regex("^[1-9][0-9]*s$", var.ci_pam_max_grant_duration))
    error_message = "ci_pam_max_grant_duration must be a positive integer followed by 's', e.g. '3600s'."
  }
}

variable "ci_pam_require_approver_justification" {
  description = "Whether approvers must supply a written justification when approving a PAM grant."
  type        = bool
  default     = true
}
