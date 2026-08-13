# Environment Guidance

This note gives working guidance for how to use environments in this Terraform template.
It is intended to align with UK Civil Service and wider government terminology, especially the Government Security Classifications Policy, but it is not a substitute for formal security, information assurance, or accreditation decisions.

## Design principle

Each Google Cloud project is a trust boundary for one environment.
This repository therefore keeps a separate Terraform root for each environment so that:

- identities, state, quotas, policies, and audit trails are separated by environment
- production access can be controlled independently from non-production access
- data handling controls can be tightened as delivery moves towards live service use
- changes can be promoted between environments without sharing the same project boundary

In service request terms, teams can ask for these environment types:

- sandbox
- non-production
- pre-production
- production

## Classification terminology

UK government's formal security classifications are `OFFICIAL`, `SECRET`, and `TOP SECRET`, with `OFFICIAL-SENSITIVE` used as a handling caveat within `OFFICIAL`.

Teams also often use local working labels such as `public`, `public internal`, or `official`. Those labels can be useful operationally, but they are not separate HMG security classifications. In practice:

- `public` data is suitable for open publication
- `public internal` data is usually still handled at `OFFICIAL`
- most routine government service data is handled at `OFFICIAL`
- more sensitive operational, personal, commercial, or security-related material may require `OFFICIAL-SENSITIVE` handling controls
- `SECRET` data needs a deliberately designed hosting and operating model and should not be assumed to be in scope for this template by default

## Recommended use of each environment

| Environment | Main use | Data and assurance guidance |
| --- | --- | --- |
| Sandbox | Early exploration, proof of concept work, and low-risk experimentation | Prefer synthetic, anonymised, or openly published data only. Use lighter controls than later environments, but keep access controlled. Suitable for `public` data and some low-risk `OFFICIAL` material by agreement. Not suitable for `OFFICIAL-SENSITIVE`, `SECRET`, or live production-identifiable data. |
| Non-production | Day-to-day development, integration, and feature testing | Use synthetic data by default. Masked or minimised `OFFICIAL` data may be acceptable where needed for testing and agreed by the information owner. Baseline controls such as least privilege, logging, and repeatable deployment should be in place. `OFFICIAL-SENSITIVE` should be by exception only. |
| Pre-production | Final release validation, operational rehearsal, and assurance before go-live | Keep this as close to production as practical for controls, monitoring, and support arrangements. Synthetic data is still preferred, but tightly controlled production-like data may be justified where needed. Suitable for `OFFICIAL`, and sometimes `OFFICIAL-SENSITIVE` where the live service is designed for it. |
| Production | Live service delivery and operational processing | This is the highest-assurance environment in the delivery lifecycle. Live data may be processed here where the service is approved to do so. Suitable for the classifications the live service is formally approved to handle, commonly `OFFICIAL` and sometimes `OFFICIAL-SENSITIVE`. `SECRET` requires a separate design and approval route. |

## Practical interpretation for service requests

When a team asks for an environment through the service desk, the request should make clear:

- which of `sandbox`, `non-production`, `pre-production`, or `production` is needed
- whether the environment is expected to handle only synthetic data or any real data
- the highest expected handling need, for example `public`, `OFFICIAL`, or `OFFICIAL-SENSITIVE`
- whether the environment must connect to production-adjacent systems or only lower environments
- any assurance needs such as penetration testing, operational readiness review, or go-live evidence

This helps the platform team apply the right controls from the start instead of retrofitting them later.

## Default guardrails

Unless a service has an explicitly approved exception, this template should be used with these defaults:

- sandbox should not contain live personal, commercial, or operational data
- non-production should default to synthetic or masked data
- pre-production should mirror production controls more closely than production data volumes
- production access should be restricted to the smallest practical support group
- anything involving `OFFICIAL-SENSITIVE` should be documented with the service's security and information management leads
- anything involving `SECRET` or above should be treated as a separate architecture and assurance conversation, not a routine environment request

## Review points

This guidance should be reviewed when:

- a new service needs to process more sensitive data than originally expected
- departmental security teams issue updated hosting or assurance requirements
- the environment model changes, for example adding a dedicated test environment between non-production and pre-production
- supplier, residency, or connectivity constraints change the trust boundary assumptions
