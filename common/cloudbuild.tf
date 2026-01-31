# Prepare: https://docs.cloud.google.com/build/docs/automating-builds/github/connect-repo-github?hl=ja&generation=2nd-gen
resource "google_cloudbuildv2_repository" "cloud_functions" {
  location          = "asia-northeast1"
  name              = "cloud-functions"
  parent_connection = "github"
  remote_uri        = "https://github.com/ureuzy/cloud_functions.git"
}

resource "google_cloudbuild_trigger" "mitene_downloader" {
  location        = "asia-northeast1"
  name            = "mitene-downloader"
  service_account = google_service_account.cloudbuild.id

  repository_event_config {
    repository = google_cloudbuildv2_repository.cloud_functions.id
    push {
      branch = "^main$"
    }
  }
  included_files = ["mitene-downloader/**"]
  filename       = "mitene-downloader/cloudbuild.yaml"

  substitutions = {
    _REGION         = "asia-northeast1"
    _CONTAINER_NAME = "mitene-downloader"
    _REPOSITORY     = google_artifact_registry_repository.common.name
    _PIPELINE_NAME  = google_clouddeploy_delivery_pipeline.mitene_downloader.name
  }
}
