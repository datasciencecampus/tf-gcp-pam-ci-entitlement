<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 6.0, < 7.44 |

## Providers

No providers.

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_ci_pam_entitlement"></a> [ci\_pam\_entitlement](#module\_ci\_pam\_entitlement) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | Numeric Google Cloud organisation ID. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud project ID for the sandbox environment. | `string` | n/a | yes |
| <a name="input_target_service_account_email"></a> [target\_service\_account\_email](#input\_target\_service\_account\_email) | Email of the CI service account that will request JIT grants. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_ci_pam_entitlement_name"></a> [ci\_pam\_entitlement\_name](#output\_ci\_pam\_entitlement\_name) | Fully-qualified PAM entitlement name. |
| <a name="output_target_sa_pam_grants_custom_role_name"></a> [target\_sa\_pam\_grants\_custom\_role\_name](#output\_target\_sa\_pam\_grants\_custom\_role\_name) | Fully-qualified project custom role name for PAM grant lifecycle actions. |
<!-- END_TF_DOCS -->
