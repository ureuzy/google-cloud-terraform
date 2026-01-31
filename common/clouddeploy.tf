resource "google_clouddeploy_delivery_pipeline" "mitene_downloader" {
  location    = "asia-northeast1"
  name        = "mitene-downloader-job-pipeline"
  description = "Delivery pipeline for mitene-downloader Cloud Run Job"

  serial_pipeline {
    stages {
      target_id = google_clouddeploy_target.mitene_downloader.name
    }
  }
}

resource "google_clouddeploy_target" "mitene_downloader" {
  location    = "asia-northeast1"
  name        = "mitene-downloader-job-target"
  description = "Target for Cloud Run Jobs in common project"
  execution_configs {
    usages          = ["RENDER", "DEPLOY"]
    service_account = google_service_account.clouddeploy.email
  }
  run {
    location = "projects/${data.google_project.main.project_id}/locations/asia-northeast1"
  }
}
