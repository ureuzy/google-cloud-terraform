# common

Common infrastructure resources for application workloads.

- **Project**: `ureuzy-common`
- **Workspace**: `google-cloud-terraform-common`

## Resources

| File | Description |
|------|-------------|
| projects.tf | Project data source and API enablement |
| cloudrun.tf | Cloud Run services and jobs |
| cloudbuild.tf | Cloud Build triggers (GitHub push to main) |
| clouddeploy.tf | Cloud Deploy pipelines and targets |
| gke.tf | GKE Autopilot cluster |
| schedulers.tf | Cloud Scheduler jobs for periodic Cloud Run execution |
| serviceaccounts.tf | Service accounts (managed via `for_each`) |
| iam.tf | IAM bindings and public access settings |
| secrets.tf | Secret Manager secrets (managed via `for_each`) |
| artifactregistry.tf | Artifact Registry (Docker) with cleanup policy |
| storage.tf | Cloud Storage buckets |
| pubsub.tf | Pub/Sub topics and subscriptions |
| monitoring.tf | Monitoring and alerting |

## Cloud Run Services

| Name | Type | Scheduler |
|------|------|-----------|
| mitene-downloader | Job | Daily 0:00 JST |
| billing-monitor | Job | Daily 0:00 JST |
| activity-analyzer | Job | Weekly Mon 0:00 JST |
| ai-reporter | Job | Daily 0:00 JST |
| ai-sensei-daily-poster | Job | Daily 9:00 JST |
| ai-sensei-event-handler | Service | - |
| audit-alert | Service | - |
| common-api | Service | - |

## Architecture

### Runtime

```mermaid
flowchart TB
  user(["Browser<br/>home.ureuzy.io"])
  slack(["Slack"])

  subgraph org["Organization: ureuzy.io"]
    direction TB
    orgsink["Org Log Sink<br/>all audit logs"]

    subgraph sys["ureuzy-org-system"]
      logs[("Cloud Logging<br/>audit logs")]
      iamsink["Log Sink<br/>SetIamPolicy only"]
      bq[("BigQuery<br/>gcp_billing_export")]
    end

    subgraph common["ureuzy-common"]
      sched["Cloud Scheduler"]
      pubsub["Pub/Sub<br/>audit-alert"]
      subgraph jobs["Cloud Run Jobs"]
        mitene["mitene-downloader<br/>daily 0:00"]
        billing["billing-monitor<br/>daily 0:00"]
        activity["activity-analyzer<br/>weekly Mon 0:00"]
        reporter["ai-reporter<br/>daily 0:00"]
        poster["ai-sensei-daily-poster<br/>daily 9:00"]
      end
      subgraph svcs["Cloud Run Services"]
        audit["audit-alert<br/>internal only"]
        api["common-api<br/>public"]
        handler["ai-sensei-event-handler<br/>public"]
      end
      photos[("GCS<br/>ureuzy-family-photos")]
      cache[("GCS<br/>ureuzy-odekake-cache")]
      gapis["Maps / Places / Routes /<br/>YouTube APIs"]
    end

    subgraph ai["ureuzy-ai"]
      vertex["Vertex AI / Gemini<br/>cache disabled"]
      fs[("Firestore")]
    end
  end

  orgsink --> logs --> iamsink --> pubsub -->|push| audit
  sched --> jobs

  billing -->|read| bq
  mitene -->|write| photos
  reporter & poster --> vertex
  handler --> vertex & fs
  api --> photos & cache & gapis & vertex

  user --> api
  user -->|signed URL| photos
  user -->|Maps JS key| gapis
  slack -->|events| handler
  jobs & audit -.->|notify| slack
```

### CI/CD

```mermaid
flowchart LR
  gh["GitHub<br/>ureuzy/cloud_functions"]
  tfc["Terraform Cloud<br/>org: ureuzy"]

  subgraph sys["ureuzy-org-system"]
    wif["Workload Identity Federation"]
  end

  subgraph common["ureuzy-common"]
    cb["Cloud Build<br/>trigger per app dir<br/>push to main"]
    ar[("Artifact Registry<br/>common / keep latest 5")]
    cd["Cloud Deploy<br/>pipeline per app"]
    run["Cloud Run<br/>Jobs / Services"]
  end

  gh --> cb --> ar
  cb --> cd --> run
  ar -.->|image| run
  tfc -->|OIDC| wif -->|terraform apply| common
```

Cloud Run Job/Service definitions (`job.yaml` / `service.yaml`) live in `ureuzy/cloud_functions`; Terraform only imports them and ignores `template` changes. Dotted Slack edges are inferred from the Slack secrets, not defined in Terraform.

Not drawn: Secret Manager (used by most Cloud Run apps) and the Monitoring alert. See the [root README](../README.md) for the organization-wide view.
