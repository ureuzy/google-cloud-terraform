resource "google_cloud_run_v2_job" "mitene_downloader" {
  name     = "mitene-downloader"
  location = "asia-northeast1"

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

resource "google_cloud_run_v2_job" "activity_analyzer" {
  name     = "activity-analyzer"
  location = "asia-northeast1"

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
          value = "#google_cloud_alert" # デフォルト値を設定
        }
        env {
          name  = "DAYS_AFTER_CREATION"
          value = "7"
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

resource "google_cloud_run_v2_service" "audit_alert" {
  name     = "audit-alert"
  location = "asia-northeast1"
  ingress  = "INGRESS_TRAFFIC_INTERNAL_ONLY"

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
