# https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/language/terraform
terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "pam_service_agent" {
  project = var.project_id
  role    = "roles/privilegedaccessmanager.serviceAgent"
  member  = "serviceAccount:service-org-${var.org_id}@gcp-sa-pam.iam.gserviceaccount.com"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam_custom_role
resource "google_project_iam_custom_role" "target_sa_pam_grants_manager" {
  project     = var.project_id
  role_id     = var.target_sa_pam_grants_role_id
  title       = "PAM Grants Manager"
  description = "Least-privilege role for CI target service account PAM grant lifecycle actions"
  permissions = [
    "privilegedaccessmanager.grants.create",
    "privilegedaccessmanager.grants.get",
    "privilegedaccessmanager.grants.revoke",
  ]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "target_sa_pam_grants_manager" {
  project = var.project_id
  role    = google_project_iam_custom_role.target_sa_pam_grants_manager.name
  member  = "serviceAccount:${var.target_service_account_email}"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/privileged_access_manager_entitlement
resource "google_privileged_access_manager_entitlement" "terraform_apply" {
  entitlement_id       = var.ci_pam_entitlement_id
  location             = "global"
  parent               = "projects/${var.project_id}"
  max_request_duration = var.ci_pam_max_grant_duration

  depends_on = [google_project_iam_member.pam_service_agent]

  eligible_users {
    principals = ["serviceAccount:${var.target_service_account_email}"]
  }

  privileged_access {
    gcp_iam_access {
      resource      = "//cloudresourcemanager.googleapis.com/projects/${var.project_id}"
      resource_type = "cloudresourcemanager.googleapis.com/Project"

      dynamic "role_bindings" {
        for_each = var.ci_pam_elevated_roles
        content {
          role = role_bindings.value
        }
      }
    }
  }

  requester_justification_config {
    unstructured {}
  }

  dynamic "approval_workflow" {
    for_each = length(var.ci_pam_approver_principals) > 0 ? [1] : []
    content {
      manual_approvals {
        require_approver_justification = var.ci_pam_require_approver_justification
        steps {
          approvals_needed = 1
          approvers {
            principals = var.ci_pam_approver_principals
          }
        }
      }
    }
  }
}
