resource "google_cloud_run_v2_job" "mitene_downloader" {
  name     = "mitene-downloader"
  location = "asia-northeast1"
  deletion_protection = false

  template {
    template {
      containers {
        image = "asia-northeast1-docker.pkg.dev/${data.google_project.main.project_id}/${google_artifact_registry_repository.common.repository_id}/mitene-downloader:ad9ad3e"

        env {
          name  = "CHANNEL"
          value = "#google_cloud"
        }
        env {
          name  = "BUCKET_NAME"
          value = "ureuzy-family-photos"
        }
        env {
          name = "SLACK_WEBHOOK"
          value_source {
            secret_key_ref {
              secret  = google_secret_manager_secret.slack_webhook.secret_id
              version = "latest"
            }
          }
        }
        env {
          name = "PHOTO_URL"
          value_source {
            secret_key_ref {
              secret  = google_secret_manager_secret.mitene_url.secret_id
              version = "latest"
            }
          }
        }
      }
      service_account = google_service_account.mitene_downloader.email
    }
  }

  lifecycle {
    ignore_changes = [
      template[0]
    ]
  }
}

# define: https://github.com/ureuzy/cloud_functions/blob/main/mitene-downloader/job.yaml
import {
  id = "projects/ureuzy-common/locations/asia-northeast1/jobs/mitene-downloader"
  to = google_cloud_run_v2_job.mitene_downloader
}

resource "google_cloud_run_v2_job" "activity_analyzer" {
  name     = "activity-analyzer"
  location = "asia-northeast1"
  deletion_protection = false

  template {
    template {
      containers {
        image = "asia-northeast1-docker.pkg.dev/${data.google_project.main.project_id}/${google_artifact_registry_repository.common.repository_id}/activity-analyzer:latest"

        env {
          name = "SLACK_WEBHOOK"
          value_source {
            secret_key_ref {
              secret  = google_secret_manager_secret.slack_webhook.secret_id
              version = "latest"
            }
          }
        }
        env {
          name  = "CHANNEL"
          value = "#google_cloud"
        }
        env {
          name  = "DAYS_AFTER_CREATION"
          value = "30"
        }
      }
      service_account = google_service_account.activity_analyzer.email
    }
  }

  lifecycle {
    ignore_changes = [
      template[0]
    ]
  }
}

# define: https://github.com/ureuzy/cloud_functions/blob/main/activity-analyzer/job.yaml
import {
  id = "projects/ureuzy-common/locations/asia-northeast1/jobs/activity-analyzer"
  to = google_cloud_run_v2_job.activity_analyzer
}

resource "google_cloud_run_v2_service" "audit_alert" {
  name     = "audit-alert"
  location = "asia-northeast1"
  ingress  = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  deletion_protection = false

  template {
    containers {
      image = "asia-northeast1-docker.pkg.dev/${data.google_project.main.project_id}/${google_artifact_registry_repository.common.repository_id}/audit-alert:latest"

        env {
          name = "SLACK_WEBHOOK"
          value_source {
            secret_key_ref {
              secret  = google_secret_manager_secret.slack_webhook.secret_id
              version = "latest"
            }
          }
        }
        env {
          name  = "CHANNEL"
          value = "#google_cloud"
        }
        env {
          name  = "STORAGE_SCOPE"
          value = "projects/ureuzy-org-system/locations/global/buckets/_Default/views/_AllLogs"
        }
        env {
          name  = "PROJECT"
          value = "ureuzy-org-system"
        }
      }
      service_account = google_service_account.audit_alert.email
    }

  lifecycle {
    ignore_changes = [
      client,
      client_version,
      template[0]
    ]
  }
}

# define: https://github.com/ureuzy/cloud_functions/blob/main/audit-alert/service.yaml
import {
  id = "projects/ureuzy-common/locations/asia-northeast1/services/audit-alert"
  to = google_cloud_run_v2_service.audit_alert
}

resource "google_cloud_run_v2_job" "ai_web_summarizer" {
  name                = "ai-web-summarizer"
  location            = "asia-northeast1"
  deletion_protection = false

  template {
    template {
      containers {
        image = "asia-northeast1-docker.pkg.dev/${data.google_project.main.project_id}/${google_artifact_registry_repository.common.repository_id}/ai-web-summarizer:latest"

        env {
          name = "SLACK_WEBHOOK"
          value_source {
            secret_key_ref {
              secret  = google_secret_manager_secret.slack_webhook.secret_id
              version = "latest"
            }
          }
        }
        env {
          name  = "CHANNEL"
          value = "#google_cloud"
        }
        env {
          name  = "TARGET_URLS"
          value = "https://example.com"
        }
        env {
          name  = "PROJECT_ID"
          value = data.google_project.main.project_id
        }
        env {
          name  = "LOCATION"
          value = "asia-northeast1"
        }
        env {
          name  = "GEMINI_MODEL"
          value = "gemini-1.5-flash"
        }
      }
      service_account = google_service_account.ai_web_summarizer.email
    }
  }

  lifecycle {
    ignore_changes = [
      template[0]
    ]
  }
}

# define: https://github.com/ureuzy/cloud_functions/blob/main/ai-web-summarizer/job.yaml
import {
  id = "projects/ureuzy-common/locations/asia-northeast1/jobs/ai-web-summarizer"
  to = google_cloud_run_v2_job.ai_web_summarizer
}
