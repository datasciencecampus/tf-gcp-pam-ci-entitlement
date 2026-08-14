output "ci_pam_entitlement_name" {
  description = "Fully-qualified PAM entitlement name. Set this as the _PAM_ENTITLEMENT_NAME substitution variable in the Cloud Build apply trigger."
  value       = google_privileged_access_manager_entitlement.terraform_apply.name
}

output "target_sa_pam_grants_custom_role_name" {
  description = "Fully-qualified project custom role name that grants PAM grant lifecycle actions to the target service account."
  value       = google_project_iam_custom_role.target_sa_pam_grants_manager.name
}
