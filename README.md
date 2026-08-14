# tf-gcp-pam-ci-entitlement

A Terraform module that provisions a [Google Privileged Access Manager (PAM)](https://cloud.google.com/iam/docs/pam-overview) entitlement for just-in-time (JIT) elevation of a CI/CD service account.

This is intended for CI pipelines (e.g. Cloud Build) that require short-lived, audited write access to a Google Cloud project during `terraform apply`, without holding permanent elevated IAM bindings on the service account.

## How it works

1. The module creates a PAM entitlement scoped to the target project.
2. The nominated CI service account is the only eligible requester.
3. Elevated roles are granted for the duration of the build and revoked on completion.
4. An optional approval step can be added for higher-assurance environments.
5. A project-level custom role is created and assigned to the target service account for PAM grant lifecycle actions.

## Usage

```hcl
module "ci_pam_entitlement" {
  source = "git::https://github.com/datasciencecampus/tf-gcp-pam-ci-entitlement.git"

  project_id                   = "my-project-id"
  org_id                       = "123456789012"
  target_service_account_email = "terraform@my-project-id.iam.gserviceaccount.com"
  target_sa_pam_grants_role_id = "pamGrantsManager"

  ci_pam_elevated_roles = [
    "roles/editor",
  ]

  # Optional: require human approval before granting elevated access
  ci_pam_approver_principals = [
    "group:platform-team@example.gov.uk",
  ]
}
```

See [examples/minimal](examples/minimal) for a complete working example.

## Repository structure

- `.github/`: GitHub Actions workflows, issue templates, and Dependabot config.
- `configs/`: shared configuration for linting and security scanning tools.
- `docs/`: project documentation and architecture decision records.
- `examples/`: working usage examples for this module.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | 7.44.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [google_privileged_access_manager_entitlement.terraform_apply](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/privileged_access_manager_entitlement) | resource |
| [google_project_iam_custom_role.target_sa_pam_grants_manager](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |
| [google_project_iam_member.pam_service_agent](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.target_sa_pam_grants_manager](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_ci_pam_approver_principals"></a> [ci\_pam\_approver\_principals](#input\_ci\_pam\_approver\_principals) | Google identity principals authorised to approve PAM grants (e.g. 'user:engineer@example.gov.uk', 'group:platform-team@example.gov.uk'). An empty list enables auto-approval; suitable for sandbox environments only. | `list(string)` | `[]` | no |
| <a name="input_ci_pam_elevated_roles"></a> [ci\_pam\_elevated\_roles](#input\_ci\_pam\_elevated\_roles) | IAM roles to make available via JIT elevation. These are the write/admin roles removed from permanent assignment on the target service account. | `list(string)` | n/a | yes |
| <a name="input_ci_pam_entitlement_id"></a> [ci\_pam\_entitlement\_id](#input\_ci\_pam\_entitlement\_id) | ID for the PAM entitlement. Must be unique within the project location. | `string` | `"ci-terraform-apply"` | no |
| <a name="input_ci_pam_max_grant_duration"></a> [ci\_pam\_max\_grant\_duration](#input\_ci\_pam\_max\_grant\_duration) | Maximum duration for a PAM grant in seconds notation (e.g. '7200s'). Should cover the worst-case apply runtime; the grant is revoked programmatically on build completion. | `string` | `"7200s"` | no |
| <a name="input_ci_pam_require_approver_justification"></a> [ci\_pam\_require\_approver\_justification](#input\_ci\_pam\_require\_approver\_justification) | Whether approvers must supply a written justification when approving a PAM grant. | `bool` | `true` | no |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | Numeric Google Cloud organisation ID. Used to construct the PAM service agent identity. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud project ID for the environment. | `string` | n/a | yes |
| <a name="input_target_sa_pam_grants_role_id"></a> [target\_sa\_pam\_grants\_role\_id](#input\_target\_sa\_pam\_grants\_role\_id) | Role ID for the project-level custom IAM role granting PAM grant lifecycle actions to the target service account. | `string` | `"pamGrantsManager"` | no |
| <a name="input_target_service_account_email"></a> [target\_service\_account\_email](#input\_target\_service\_account\_email) | Email address of the target Terraform service account. This SA will be the eligible requester for JIT grants. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_ci_pam_entitlement_name"></a> [ci\_pam\_entitlement\_name](#output\_ci\_pam\_entitlement\_name) | Fully-qualified PAM entitlement name. Set this as the \_PAM\_ENTITLEMENT\_NAME substitution variable in the Cloud Build apply trigger. |
| <a name="output_target_sa_pam_grants_custom_role_name"></a> [target\_sa\_pam\_grants\_custom\_role\_name](#output\_target\_sa\_pam\_grants\_custom\_role\_name) | Fully-qualified project custom role name that grants PAM grant lifecycle actions to the target service account. |
<!-- END_TF_DOCS -->

## Notes

- Environment usage, assurance expectations, and data handling guidance are described in this README.
  - `privilegedaccessmanager.grants.get`
  - `privilegedaccessmanager.grants.list`
  - `privilegedaccessmanager.grants.revoke`
