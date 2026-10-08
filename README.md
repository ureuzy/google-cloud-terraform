# google-cloud-terraform

Google Cloud Platform infrastructure managed with Terraform, using Terraform Cloud as the remote backend.

## Structure

| Directory | Workspace | GCP Project | Purpose |
|-----------|-----------|-------------|---------|
| [organization/](organization/) | `google-cloud-terraform` | `ureuzy-org-system` | Org policies, projects, billing, logging, workload identity |
| [common/](common/) | `google-cloud-terraform-common` | `ureuzy-common` | Cloud Run, Cloud Build/Deploy, GKE, secrets, storage |
| [ai/](ai/) | `google-cloud-terraform-ai` | `ureuzy-ai` | Firestore, AI Platform permissions |

Each directory is an independent Terraform root module with its own state.

## Architecture

```mermaid
flowchart TB
  tfc(["Terraform Cloud<br/>org: ureuzy"])
  gha(["GitHub Actions<br/>owner: ureuzy"])
  billing["Billing Account<br/>Budget JPY 10,000 / month (alert 50%)<br/>linked to all projects"]

  subgraph org["Organization: ureuzy.io"]
    direction TB

    subgraph settings["Org-level settings (organization/)"]
      direction LR
      iam["Org IAM<br/>domain:ureuzy.io: projectCreator, billing.creator<br/>gcp-owners: owner, viewer<br/>gcp-organization-admins: org / folder / billing / orgpolicy admin"]
      policies["Org Policies<br/>no auto IAM grants for default SAs<br/>Cloud Functions ingress<br/>(exception tag: allUsersIngress=true)"]
      audit["Audit Logging<br/>Data Access logs: iam, sts<br/>Org sink: all audit logs → ureuzy-org-system"]
    end

    sys["<b>ureuzy-org-system</b><br/>workspace: organization/<br/>──────────<br/>Workload Identity (terraform, github-actions)<br/>Aggregated audit logs<br/>BigQuery gcp_billing_export<br/>KMS pubsub_key"]
    common["<b>ureuzy-common</b><br/>workspace: common/<br/>──────────<br/>Service Accounts (all apps)<br/>Cloud Run Jobs / Services<br/>Cloud Build / Deploy / Artifact Registry<br/>GCS / Secret Manager / Pub/Sub"]
    ai["<b>ureuzy-ai</b><br/>workspace: ai/<br/>──────────<br/>Vertex AI (Gemini)<br/>Firestore"]
    ureuzy["<b>ureuzy</b><br/>Firebase<br/>(project only)"]
  end

  tfc & gha -->|OIDC| sys
  audit -->|all projects' audit logs| sys
  sys -->|SetIamPolicy logs<br/>to Pub/Sub audit-alert| common
  common -->|billing-monitor<br/>reads billing export| sys
  common -->|app SAs use<br/>Vertex AI / Firestore| ai
  billing -->|export| sys
```

Terraform Cloud authenticates to every workspace through the Workload Identity pool in `ureuzy-org-system`. For the application architecture inside `ureuzy-common`, see [common/README.md](common/README.md#architecture).

## Prerequisites

- Terraform `1.14.4`
- Terraform Cloud organization: `ureuzy`
- GCP region: `asia-northeast1` (Tokyo)
- Google provider: `~> 7.16.0`

## Usage

```bash
cd <directory>  # organization/ or common/ or ai/
terraform init
terraform plan
terraform apply
```

Before changing anything, read [DEVELOPMENT.md](DEVELOPMENT.md). Coding agents also follow [AGENTS.md](AGENTS.md).

## Dependency

```
organization/ --> common/ --> ai/
```

`organization/` creates projects and org-level resources. `common/` defines service accounts referenced by `ai/` via data sources.
