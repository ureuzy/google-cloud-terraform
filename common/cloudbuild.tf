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

resource "google_cloudbuild_trigger" "activity_analyzer" {
  location        = "asia-northeast1"
  name            = "activity-analyzer"
  service_account = google_service_account.cloudbuild.id

  repository_event_config {
    repository = google_cloudbuildv2_repository.cloud_functions.id
    push {
      branch = "^main$"
    }
  }
  included_files = ["activity-analyzer/**"]
  filename       = "activity-analyzer/cloudbuild.yaml"

  substitutions = {
    _REGION         = "asia-northeast1"
    _CONTAINER_NAME = "activity-analyzer"
    _REPOSITORY     = google_artifact_registry_repository.common.name
    _PIPELINE_NAME  = google_clouddeploy_delivery_pipeline.activity_analyzer.name
  }
}

resource "google_cloudbuild_trigger" "audit_alert" {
  location        = "asia-northeast1"
  name            = "audit-alert"
  service_account = google_service_account.cloudbuild.id

  repository_event_config {
    repository = google_cloudbuildv2_repository.cloud_functions.id
    push {
      branch = "^main$"
    }
  }
  included_files = ["audit-alert/**"]
  filename       = "audit-alert/cloudbuild.yaml"

  substitutions = {
    _REGION         = "asia-northeast1"
    _CONTAINER_NAME = "audit-alert"
    _REPOSITORY     = google_artifact_registry_repository.common.name
    _PIPELINE_NAME  = google_clouddeploy_delivery_pipeline.audit_alert.name
  }
}

resource "google_cloudbuild_trigger" "ai_web_summarizer" {
  location        = "asia-northeast1"
  name            = "ai-web-summarizer"
  service_account = google_service_account.cloudbuild.id

  repository_event_config {
    repository = google_cloudbuildv2_repository.cloud_functions.id
    push {
      branch = "^main$"
    }
  }
  included_files = ["ai-web-summarizer/**"]
  filename       = "ai-web-summarizer/cloudbuild.yaml"

  substitutions = {
    _REGION         = "asia-northeast1"
    _CONTAINER_NAME = "ai-web-summarizer"
    _REPOSITORY     = google_artifact_registry_repository.common.name
    _PIPELINE_NAME  = google_clouddeploy_delivery_pipeline.ai_web_summarizer.name
  }
}
