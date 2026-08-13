# Copilot Instructions for Cloud IaC Repositories

These instructions are intended for cloud infrastructure-as-code repositories. They define how Copilot should generate and modify infrastructure-as-code for multi-environment cloud estates (primarily Google Cloud).

## Scope

- MUST treat this repository as infrastructure-as-code for multiple environments and projects.
- MUST optimize for security, operability, and maintainability over speed of delivery.
- SHOULD produce minimal, explicit, reviewable Terraform changes.

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

## Decision Records (ADR)

- MUST record significant architecture and security decisions as ADRs in docs/adr/.
- MUST add an ADR when introducing or changing any of the following:
  - trust boundaries between environments or projects
  - IAM model, privileged access, or identity delegation
  - network segmentation or connectivity posture
  - data classification handling or encryption strategy
  - logging, monitoring, or incident response approach
- SHOULD include context, decision, alternatives, consequences, and review date in each ADR.

## Documentation (Diataxis)

- MUST keep documentation in docs/.
- MUST follow Diataxis categories:
  - tutorials for learning-oriented, step-by-step onboarding
  - how-to guides for task-focused operational procedures
  - reference for factual, lookup-oriented technical detail
  - explanations for rationale, trade-offs, and architecture context
- SHOULD place new documents in a folder structure that makes the Diataxis type clear.
- SHOULD link related ADRs from relevant docs pages.

Reference: https://diataxis.fr/

## Copilot Behavior Rules

When generating code or review suggestions, Copilot MUST:

- default to least privilege IAM and avoid broad roles unless explicitly justified
- prefer managed services and secure defaults over custom security workarounds
- make environment assumptions explicit in comments and variable naming
- highlight security-impacting trade-offs and recommend an ADR where needed
- avoid introducing hidden coupling across environments

When uncertain, Copilot SHOULD ask for clarification about:

- target environment and data classification
- required assurance level for the change
- existing ADRs or policy constraints that may apply

## Pull Request and Review Expectations

- MUST describe security impact and environment impact in PR summaries.
- MUST call out any temporary exceptions and when they will be removed.
- SHOULD include links to updated docs and ADRs where applicable.

## Non-Goals

- These instructions do not prescribe a specific security information & event management, monitoring vendor, or continuous integration platform.
- These instructions do not replace formal organizational security policy.
