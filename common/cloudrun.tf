resource "google_cloud_run_v2_job" "mitene_downloader" {
  project  = data.google_project.main.project_id
  name     = "mitene-downloader"
  location = "asia-northeast1"

  template {
    template {
      containers {
        image = "asia-northeast1-docker.pkg.dev/${data.google_project.main.project_id}/${google_artifact_registry_repository.common.repository_id}/mitene-downloader:latest"

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
      template[0].template[0].containers[0].image,
    ]
  }
}
