resource "google_artifact_registry_repository" "common" {
  project       = data.google_project.main.project_id
  location      = "asia-northeast1"
  repository_id = "common"
  format        = "DOCKER"
}

resource "google_cloudbuild_trigger" "mitene_downloader" {
  project     = data.google_project.main.project_id
  location    = "asia-northeast1"
  name        = "mitene-downloader"
  description = "Build and Deploy mitene-downloader to Cloud Run Job"

  github {
    owner = "ureuzy"
    name  = "cloud_functions"
    push {
      branch = "^main$"
    }
  }

  included_files = ["mitene-downloader/**"]

  filename = "mitene-downloader/cloudbuild.yaml"

  substitutions = {
    _REGION          = "asia-northeast1"
    _REPOSITORY      = google_artifact_registry_repository.common.name
    _PIPELINE_NAME   = "mitene-downloader"
  }
}
