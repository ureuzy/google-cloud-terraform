# Development Guide

How to change this repository. For what is deployed, see [README.md](README.md).

## Workflow

1. Create a branch from `main`: `feat/<topic>` or `fix/<topic>`.
2. Edit the Terraform code in the workspace directory that owns the resource (see [Where things go](#where-things-go)).
3. Run `terraform fmt` and `terraform validate` in that directory.
4. Run `terraform plan` in that directory. It runs on Terraform Cloud, so the plan uses the workspace's own credentials.
5. Update the documentation (see [Documentation](#documentation)).
6. Open a pull request. Apply after merging.

When a change spans workspaces, apply in dependency order: `organization/` → `common/` → `ai/`. For example, a new service account must exist in `common/` before `ai/` can look it up.

### Commit messages

Use Conventional Commits with the workspace as the scope, and describe what the change lets something do:

```
feat(common): let common-api keep visited places in the photo bucket
fix(ai): correct the provider region name
```

Scopes: `organization`, `common`, `ai`. Leave the scope out for repository-wide changes such as docs or Renovate.

## Where things go

| Change | Workspace |
|--------|-----------|
| Projects, org IAM, org policies, audit logging, billing, Workload Identity | `organization/` |
| Application workloads: Cloud Run, CI/CD, schedulers, storage, secrets, service accounts | `common/` |
| AI resources (Vertex AI, Firestore) and the permissions apps need for them | `ai/` |

- All application service accounts are created in `common/serviceaccounts.tf`, even when they only need permissions in another project.
- Another workspace grants permissions to these accounts by looking them up with a `data "google_service_account"` block (see `ai/serviceaccounts.tf`, `organization/serviceaccounts.tf`). Do not use `terraform_remote_state`.
- Each file holds one kind of resource (`iam.tf`, `storage.tf`, `cloudrun.tf`, ...). Add to the existing file rather than creating a new one per feature.

## Conventions

### General

- Region: `asia-northeast1`. Use this region unless a resource needs a multi-region location (for example, the photo bucket uses `ASIA`).
- Turn on APIs by adding them to `activate_apis` in the workspace's `projects.tf`. Add `depends_on = [module.project-services]` to resources that fail when the API is still off (for example, API keys).
- Terraform resource names use `snake_case`. GCP resource names use `kebab-case` (`mitene_downloader` → `mitene-downloader`).
- Write comments that explain *why* a setting is what it is, such as a limit, an exception, or a lifecycle rule. Japanese is fine.

### IAM

- Use `*_iam_member` resources only. Do not use `*_iam_binding` or `*_iam_policy`: they replace bindings that other workspaces or the console manage.
- Group the roles for one principal into one resource with `for_each = toset([...])` and a `# For <name> SA Permissions` comment, following `common/iam.tf`.
- Grant the narrowest scope that works: a bucket, secret, or service account rather than the project. Use IAM conditions to limit a role to object prefixes (see `common_api_photos_ai_edits`).
- Do not create service account keys. Terraform Cloud and GitHub Actions authenticate with Workload Identity Federation. Signed URLs use `signBlob` on the account itself.
- Give Cloud Run public access (`allUsers` → `roles/run.invoker`) only to services that need it, and set `ingress = "INGRESS_TRAFFIC_INTERNAL_ONLY"` on services that only receive internal traffic.

### Service accounts and secrets

- Add service accounts to the `local.service_accounts` map in `common/serviceaccounts.tf` with a description. Do not create separate `google_service_account` resources.
- Add secrets to `local.secrets` in `common/secrets.tf`. Terraform creates the secret only. Add values in the console, unless Terraform produces the value itself (see `youtube_api_key`).
- Use API keys only when a service account cannot call the API. Restrict every key to the APIs it needs, and browser keys to the referrers that use them.

### Storage

- Buckets set `uniform_bucket_level_access = true`, `public_access_prevention = "enforced"` and `force_destroy = false`.
- Add a lifecycle rule for every prefix that holds temporary or old-version data, with a comment saying why the retention period was chosen.

### Cloud Run apps

The source and the Cloud Run definition (`job.yaml` / `service.yaml`) for every app live in [ureuzy/cloud_functions](https://github.com/ureuzy/cloud_functions). Terraform creates the CI/CD around it and imports the Cloud Run resource, ignoring `template` changes. Change runtime settings such as env vars, image, or memory in `cloud_functions`, not here.

To add an app `<name>` in `common/`:

1. `serviceaccounts.tf`: add `<name>` to `local.service_accounts`.
2. `iam.tf`: grant the account its roles.
3. `cloudbuild.tf`: add a `google_cloudbuild_trigger` that copies an existing one and points to `<name>/`.
4. `clouddeploy.tf`: add a `google_clouddeploy_delivery_pipeline` and a `google_clouddeploy_target`.
5. `cloudrun.tf`: after the first deploy creates the resource, add a `google_cloud_run_v2_job` or `google_cloud_run_v2_service` with an `import` block and `lifecycle { ignore_changes = [template[0]] }`.
6. `schedulers.tf`: add a Cloud Scheduler job if the app runs on a schedule. Run it as the app's own service account.
7. Update the Cloud Run table and the diagrams in `common/README.md`.

### Versions

- Terraform and provider versions are pinned in each workspace's `versions.tf` and in `organization/.tool-versions`. Keep all three workspaces on the same versions.
- Renovate opens the version update pull requests. When updating by hand, update every workspace and the Prerequisites section in `README.md`.

## Documentation

Update the documentation in the same pull request as the code:

| What changed | Update |
|--------------|--------|
| Projects, workspaces, org-level settings, or anything that crosses projects (IAM across projects, log routing, billing, Workload Identity) | The Architecture diagram and the Structure table in [README.md](README.md) |
| Resources inside `common/` (Cloud Run apps, schedulers, CI/CD, buckets, Pub/Sub) | The Resources and Cloud Run tables and the Architecture diagrams in [common/README.md](common/README.md) |
| Files or resources in `organization/` or `ai/` | The Resources table in that directory's `README.md` |
| Versions, workflow, or conventions | [README.md](README.md) Prerequisites, this file, and [AGENTS.md](AGENTS.md) |

The diagrams are Mermaid. Check that they render before pushing, either in the GitHub preview or with:

```bash
npx -y @mermaid-js/mermaid-cli -i diagram.mmd -o diagram.png
```

Keep the root diagram at the project level: one box per project and arrows only for relationships between projects. Draw app-level detail in the workspace README.
