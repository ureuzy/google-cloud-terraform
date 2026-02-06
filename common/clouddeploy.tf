# Mitene Downloader
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

# Activity Analyzer
resource "google_clouddeploy_delivery_pipeline" "activity_analyzer" {
  location    = "asia-northeast1"
  name        = "activity-analyzer-job-pipeline"
  description = "Delivery pipeline for activity-analyzer Cloud Run Job"

  serial_pipeline {
    stages {
      target_id = google_clouddeploy_target.activity_analyzer.name
    }
  }
}

resource "google_clouddeploy_target" "activity_analyzer" {
  location    = "asia-northeast1"
  name        = "activity-analyzer-job-target"
  description = "Target for activity-analyzer Cloud Run Job"
  execution_configs {
    usages          = ["RENDER", "DEPLOY"]
    service_account = google_service_account.clouddeploy.email
  }
  run {
    location = "projects/${data.google_project.main.project_id}/locations/asia-northeast1"
  }
}

# Audit Alert
resource "google_clouddeploy_delivery_pipeline" "audit_alert" {
  location    = "asia-northeast1"
  name        = "audit-alert-pipeline"
  description = "Delivery pipeline for audit-alert Cloud Run Service"

  serial_pipeline {
    stages {
      target_id = google_clouddeploy_target.audit_alert.name
    }
  }
}

resource "google_clouddeploy_target" "audit_alert" {
  location    = "asia-northeast1"
  name        = "audit-alert-target"
  description = "Target for audit-alert Cloud Run Service"
  execution_configs {
    usages          = ["RENDER", "DEPLOY"]
    service_account = google_service_account.clouddeploy.email
  }
  run {
    location = "projects/${data.google_project.main.project_id}/locations/asia-northeast1"
  }
}

resource "google_clouddeploy_delivery_pipeline" "ai_web_summarizer" {
  location    = "asia-northeast1"
  name        = "ai-web-summarizer-job-pipeline"
  description = "Delivery pipeline for ai-web-summarizer Cloud Run Job"

  serial_pipeline {
    stages {
      target_id = google_clouddeploy_target.ai_web_summarizer.name
    }
  }
}

resource "google_clouddeploy_target" "ai_web_summarizer" {
  location    = "asia-northeast1"
  name        = "ai-web-summarizer-job-target"
  description = "Target for ai-web-summarizer Cloud Run Job"
  execution_configs {
    usages          = ["RENDER", "DEPLOY"]
    service_account = google_service_account.clouddeploy.email
  }
  run {
    location = "projects/${data.google_project.main.project_id}/locations/asia-northeast1"
  }
}
