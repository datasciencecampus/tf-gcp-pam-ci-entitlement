# Copilot Instructions for Cloud IaC Repositories

These instructions are intended for cloud infrastructure-as-code repositories. They define how Copilot should generate and modify infrastructure-as-code for multi-environment cloud estates (primarily Google Cloud).

## Scope

- MUST treat this repository as infrastructure-as-code for multiple environments and projects.
- MUST optimize for security, operability, and maintainability over speed of delivery.
- SHOULD produce minimal, explicit, reviewable Terraform changes.

## Terraform Module Repository (Critical)

- MUST treat this repository specifically as a reusable Terraform module, not as a standalone environment deployment repository.
- MUST keep suggestions aligned to module authoring patterns: inputs in variables.tf, resources in main.tf, outputs in outputs.tf, and usage examples under examples/.
- MUST prefer backward-compatible module changes and clearly call out any interface-breaking changes to variables, outputs, or resource behavior.
- MUST adapt code suggestions for module consumers across environments, avoiding hard-coded environment-specific values unless explicitly requested.
- MUST avoid suggesting unrelated application code, CI pipelines, or non-Terraform framework scaffolding unless explicitly requested by the user.
- SHOULD preserve a stable public module interface, including variable names, types, defaults, and output contracts where possible.
- SHOULD ensure examples and README usage/docs stay in sync when module inputs, outputs, or behavior changes.

### Variable and Output Validation

- MUST include variable validation blocks for security-sensitive or format-constrained inputs (for example project IDs, service account emails, role IDs, durations, and principal strings).
- MUST ensure validation error messages are clear, actionable, and user-focused.
- MUST prefer explicit variable types and nullable settings that reduce ambiguous module behavior.
- MUST define outputs as stable contracts: concise descriptions, predictable values, and no leaking of sensitive data.
- MUST avoid adding outputs that expose secrets, tokens, or internal-only identifiers.
- SHOULD mark sensitive outputs with Terraform's sensitive semantics when values may be confidential.
- SHOULD update examples and README input/output tables when validation rules or output behavior changes.

When suggesting code for this repository, Copilot MUST default to "module-safe" changes:

- minimal diffs with explicit intent
- least-privilege IAM and secure defaults
- predictable plans with clear upgrade impact for module users
- documentation updates for any module interface changes
- input validation and output contract checks as part of the change, not as optional follow-up

## Public Repository Sanitization (Critical)

- MUST treat all generated or modified content as publicly visible by default.
- MUST NOT include secrets, credentials, tokens, private keys, internal hostnames, internal project IDs, or non-public account identifiers in code, docs, comments, examples, tests, or commit/PR text.
- MUST use clearly fake placeholder values for examples (for example: example-project-id, 000000000000, ci-terraform@example.iam.gserviceaccount.com).
- MUST redact or generalize environment-specific identifiers when proposing snippets or documentation updates.
- MUST avoid copying values from logs, plans, screenshots, or local environment output into tracked files.
- SHOULD prefer reusable placeholder patterns and document where users must substitute their own values.
- SHOULD call out any suspected sensitive content discovered during edits and recommend removal before merge.

## Secure By Design (UK Government Alignment)

- MUST follow UK Government secure-by-design expectations and apply them from the start of design, not after implementation.
- MUST prioritize least privilege, strong identity boundaries, and defense in depth.
- MUST assume production-grade security controls are the target end state.
- SHOULD reference these sources when proposing security-sensitive changes:
  - NCSC Cyber Security Design Principles: https://www.ncsc.gov.uk/collection/cyber-security-design-principles
  - UK Government Security Policy Framework (SPF): https://www.gov.uk/government/publications/security-policy-framework

## Environment-Proportionate Controls

- MUST apply controls proportionate to environment risk and data sensitivity.
- MAY keep sandbox controls lighter to support rapid experimentation.
- MUST ensure production environments have robust protections, including:
  - strong IAM boundaries and least privilege
  - comprehensive auditability and monitoring
  - restrictive network and data access controls
  - explicit change control and rollback considerations
- MUST NOT justify weaker production controls because a sandbox uses lighter controls.
- SHOULD make the control uplift explicit as infrastructure moves from sandbox to non-prod, pre-prod, and prod.

## Terraform Authoring Standards

- MUST include a Terraform Registry URL comment above every resource block.
- MUST use the canonical provider resource documentation URL format.
- MUST keep the URL aligned to the resource type being defined.

Compliant example:

```hcl
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "my_bucket" {
  name     = "example-bucket"
  location = "europe-west2"
}
```

Non-compliant example:

```hcl
resource "google_storage_bucket" "my_bucket" {
  name     = "example-bucket"
  location = "europe-west2"
}
```

## Documentation (Diataxis)

- MUST keep documentation in docs/.
- MUST use a lightweight, module-proportionate Diataxis approach ("Diataxis-lite").
- MUST follow Diataxis categories when creating or restructuring docs:
  - tutorials for learning-oriented, step-by-step onboarding
  - how-to guides for task-focused operational procedures
  - reference for factual, lookup-oriented technical detail
  - explanations for rationale, trade-offs, and architecture context
- SHOULD prioritize reference and how-to content over standalone tutorial material unless onboarding needs justify it.
- SHOULD keep explanation content concise and close to the module documentation where practical.
- SHOULD place new documents in a folder structure that makes the Diataxis type clear.
- SHOULD capture security-impacting rationale in relevant docs pages when introducing significant changes.

Reference: https://diataxis.fr/

## Copilot Behavior Rules

When generating code or review suggestions, Copilot MUST:

- default to least privilege IAM and avoid broad roles unless explicitly justified
- prefer managed services and secure defaults over custom security workarounds
- make environment assumptions explicit in comments and variable naming
- highlight security-impacting trade-offs and document rationale in module docs where needed
- avoid introducing hidden coupling across environments
- prioritize module composition and reusability over one-off environment shortcuts
- keep module interface changes intentional, documented, and reviewable
- sanitize examples and documentation for public consumption

When uncertain, Copilot SHOULD ask for clarification about:

- target environment and data classification
- required assurance level for the change
- existing policy constraints or documentation requirements that may apply

## Pull Request and Review Expectations

- MUST describe security impact and environment impact in PR summaries.
- MUST call out any temporary exceptions and when they will be removed.
- SHOULD include links to updated docs where applicable.
- MUST ensure PR descriptions and review comments do not contain sensitive environment details.

## Commit Message Conventions

- MUST use Conventional Commits for all commit messages.
- MUST align commit types with release-please configuration in release-please-config.json.
- MUST prefer these types for changelog-visible changes: feat, fix, security, docs, refactor.
- MAY use these maintenance types where appropriate: chore, ci, test.
- SHOULD use concise, imperative subjects and include scope when it improves clarity (for example: fix(iam): replace unsupported PAM permission).

## Non-Goals

- These instructions do not prescribe a specific security information & event management, monitoring vendor, or continuous integration platform.
- These instructions do not replace formal organizational security policy.
