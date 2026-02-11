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

resource "google_cloudbuild_trigger" "billing_monitor" {
  location        = "asia-northeast1"
  name            = "billing-monitor"
  service_account = google_service_account.cloudbuild.id

  repository_event_config {
    repository = google_cloudbuildv2_repository.cloud_functions.id
    push {
      branch = "^main$"
    }
  }
  included_files = ["billing-monitor/**"]
  filename       = "billing-monitor/cloudbuild.yaml"

  substitutions = {
    _REGION         = "asia-northeast1"
    _CONTAINER_NAME = "billing-monitor"
    _REPOSITORY     = google_artifact_registry_repository.common.name
    _PIPELINE_NAME  = google_clouddeploy_delivery_pipeline.billing_monitor.name
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

resource "google_cloudbuild_trigger" "ai_reporter" {
  location        = "asia-northeast1"
  name            = "ai-reporter"
  service_account = google_service_account.cloudbuild.id

  repository_event_config {
    repository = google_cloudbuildv2_repository.cloud_functions.id
    push {
      branch = "^main$"
    }
  }
  included_files = ["ai-reporter/**"]
  filename       = "ai-reporter/cloudbuild.yaml"

  substitutions = {
    _REGION         = "asia-northeast1"
    _CONTAINER_NAME = "ai-reporter"
    _REPOSITORY     = google_artifact_registry_repository.common.name
    _PIPELINE_NAME  = google_clouddeploy_delivery_pipeline.ai_reporter.name
  }
}

resource "google_cloudbuild_trigger" "common_api" {
  location        = "asia-northeast1"
  name            = "common-api"
  service_account = google_service_account.cloudbuild.id

  repository_event_config {
    repository = google_cloudbuildv2_repository.cloud_functions.id
    push {
      branch = "^main$"
    }
  }
  included_files = ["common-api/**"]
  filename       = "common-api/cloudbuild.yaml"

  substitutions = {
    _REGION         = "asia-northeast1"
    _CONTAINER_NAME = "common-api"
    _REPOSITORY     = google_artifact_registry_repository.common.name
    _PIPELINE_NAME  = google_clouddeploy_delivery_pipeline.common_api.name
  }
}
