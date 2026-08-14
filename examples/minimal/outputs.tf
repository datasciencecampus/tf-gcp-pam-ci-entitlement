output "ci_pam_entitlement_name" {
  description = "Fully-qualified PAM entitlement name."
  value       = module.ci_pam_entitlement.ci_pam_entitlement_name
}

output "target_sa_pam_grants_custom_role_name" {
  description = "Fully-qualified project custom role name for PAM grant lifecycle actions."
  value       = module.ci_pam_entitlement.target_sa_pam_grants_custom_role_name
}
