# terraform-template

A starter template for creating reusable Terraform repos with best practices built in.

## Repository structure

- `.github/`: GitHub workflows, templates, and Dependabot config.
- `configs/`: shared configuration for linting and security tools.
- `docs/`: project documentation and architecture records.
- `terraform/`: Terraform code, split by environment.
  - `01_sandbox/`: sandbox environment.
  - `02_dev_nonprod/`: non-production development environment.
  - `03_stg_prod/`: pre-production or staging environment.
  - `04_prd_prod/`: production environment.
  - `modules/`: reusable Terraform modules.

## How to use

1. Review `.github/copilot-instructions.md` before you start, and adapt it for your generated repository as needed.

2. Change into the Terraform root for the environment you want to work with:

   ```bash
   cd terraform/ENVIRONMENT_ROOT
   ```

3. Initialise Terraform for that environment:

   ```bash
   terraform init
   ```

4. Plan and apply your changes using the variables and backend settings appropriate to that environment:

   ```bash
   terraform plan
   terraform apply
   ```

## Notes

- Each environment root maps to a separate Google Cloud project and should be treated as its own trust boundary.
- Environment usage, assurance expectations, and data handling guidance are described in `docs/environment-guidance.md`.
- If backend settings change, run `terraform init -reconfigure`.
