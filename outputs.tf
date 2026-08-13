output "ci_pam_entitlement_name" {
  description = "Fully-qualified PAM entitlement name. Set this as the _PAM_ENTITLEMENT_NAME substitution variable in the Cloud Build apply trigger."
  value       = google_privileged_access_manager_entitlement.terraform_apply.name
}
