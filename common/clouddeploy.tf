resource "google_clouddeploy_delivery_pipeline" "mitene_downloader" {
  project     = data.google_project.main.project_id
  location    = "asia-northeast1"
  name        = "mitene-downloader"
  description = "Delivery pipeline for mitene-downloader Cloud Run Job"

  serial_pipeline {
    stages {
      target_id = "common-run"
    }
  }
}

resource "google_clouddeploy_target" "common_run" {
  project          = data.google_project.main.project_id
  location         = "asia-northeast1"
  name             = "common-run"
  description      = "Target for Cloud Run Jobs in common project"
  execution_configs {
    usages = ["RENDER", "DEPLOY"]
  }
  run {
    location = "projects/${data.google_project.main.project_id}/locations/asia-northeast1"
  }
}
