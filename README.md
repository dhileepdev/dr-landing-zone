# AWS Terraform Landing Zone — Disaster Recovery

Standalone portfolio project: AWS Terraform landing zone for disaster recovery —
VPC, subnets, IAM, internet gateway — plus health checks, validate/plan CI and
scheduled drift detection.

## What it demonstrates

- **Terraform landing zone**: VPC, public/private subnets, IAM role, internet
  gateway, route tables — provisioned with Terraform in AWS `ap-southeast-2`.
- **DR health checks & drift detection**: GitHub Actions runs `terraform validate`
  on branches, `plan` on PRs, `apply` via manual `workflow_dispatch`, and drift
  detection on a 6-hour schedule.

## Repository layout

```
terraform/
  main.tf           # VPC, subnets, IAM, IGW, route tables
  variables.tf      # input variables
  outputs.tf        # vpc_id, subnet_ids, health_check_url, backend_bucket, dynamodb_table
  versions.tf       # AWS provider (ap-southeast-2)
  backend.hcl.example # state backend example (Floci local emulator)
.github/
  workflows/
    terraform.yml   # CI/CD: validate → plan → apply (manual) → drift
```

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.0
- [Floci](https://floci.io/) (local AWS emulator) — `floci 0.4.0`
- [AWS CLI](https://aws.amazon.com/cli/)

## Local development

### 1. Terraform landing zone (against Floci, no real AWS)

```bash
# Start the Floci AWS emulator (port 4566)
floci start

# Create the state bucket locally
aws --endpoint-url http://localhost:4566 s3 mb s3://dr-terraform-state --region ap-southeast-2

# Initialize and validate Terraform
cd terraform
cp backend.hcl.example backend.hcl
terraform init -backend-config=backend.hcl
terraform validate
```

### 2. CI/CD

`.github/workflows/terraform.yml`:

- `validate` — on push to non-`main` branches
- `plan` — on PRs
- `apply` — manual `workflow_dispatch` only (never auto-runs)
- `drift` — every 6 hours (`schedule`) or manual dispatch; commits
  `drift/last-run.json` with detected drift + changed resources

### 3. GitHub Secrets (for CI/CD)

Add to repo Settings → Secrets and variables → Actions:

| Secret | Purpose |
|--------|---------|
| `AWS_ACCESS_KEY_ID` | Terraform apply credentials (manual `workflow_dispatch` only) |
| `AWS_SECRET_ACCESS_KEY` | Terraform apply credentials (manual `workflow_dispatch` only) |

## License

MIT
