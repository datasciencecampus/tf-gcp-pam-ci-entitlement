# Minimal example: PAM CI entitlement with auto-approval (sandbox only)
#
# This example provisions the entitlement without an approval step.
# Auto-approval is appropriate only for sandbox environments.
# For non-production, pre-production, or production environments, set
# ci_pam_approver_principals to require human approval.

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference
terraform {
  required_version = ">= 1.9"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0, < 7.46"
    }
  }
}

module "ci_pam_entitlement" {
  source = "../.."

  project_id                   = var.project_id
  org_id                       = var.org_id
  target_service_account_email = var.target_service_account_email

  ci_pam_elevated_roles = [
    "roles/editor",
  ]

  # Optional: notify a central mailbox when grants are approved and activated.
  ci_pam_admin_notification_email_recipients = [
    "pam-alerts@example.invalid",
  ]

  # No approvers: auto-approval enabled. Sandbox only.
  ci_pam_approver_principals = []
}
