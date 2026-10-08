# AGENTS.md

Instructions for coding agents working in this repository. The full conventions are in [DEVELOPMENT.md](DEVELOPMENT.md). Read it before making changes.

## Repository

- Terraform for the `ureuzy.io` Google Cloud organization. There are three independent root modules, each with its own Terraform Cloud workspace: `organization/`, `common/`, `ai/`.
- Dependency order: `organization/` → `common/` → `ai/`. Workspaces refer to each other only through `data` sources with hard-coded project IDs.
- Cloud Run apps are defined in [ureuzy/cloud_functions](https://github.com/ureuzy/cloud_functions). This repository only imports them and ignores `template`.

## Rules

- **Keep the documentation in sync with the code, in the same change.** If you add, remove, or move a project, workspace, service, service account, bucket, or cross-project permission, update:
  - the Architecture diagram and the Structure table in `README.md` for organization-level or cross-project changes
  - the tables and the Architecture diagrams in `common/README.md` for changes inside `common/`
  - the Resources table in the workspace's `README.md` when you add or rename files
  - `DEVELOPMENT.md` and this file when a convention changes

  Check that every Mermaid diagram you edit renders (`npx -y @mermaid-js/mermaid-cli -i <file>.mmd -o <file>.png`).
- Put each resource in the workspace and file that already own that kind of resource. See "Where things go" in `DEVELOPMENT.md`.
- IAM: use `*_iam_member` only, never `*_iam_binding` or `*_iam_policy`. Grant the narrowest scope (a bucket, secret, or condition) rather than a project-wide role.
- Create service accounts and secrets by adding entries to `local.service_accounts` and `local.secrets` in `common/`. Never create service account keys.
- New buckets: uniform access, `public_access_prevention = "enforced"`, `force_destroy = false`, and lifecycle rules with comments.
- Region `asia-northeast1`. Enable APIs through the `project-services` module in `projects.tf`.
- Keep `versions.tf` the same in all three workspaces.
- Comment *why* a non-obvious setting exists. Match the comment style of the surrounding code (Japanese is used).

## Commands

Run these inside the workspace directory you changed:

```bash
terraform fmt
terraform validate
terraform plan   # runs remotely on Terraform Cloud
```

Do not run `terraform apply` or `terraform import` unless the user asks. Do not create or edit state by hand.

## Commits

Use Conventional Commits with the workspace as the scope, for example `feat(common): let common-api ...` or `fix(ai): ...`. Use branches named `feat/<topic>` or `fix/<topic>`.
