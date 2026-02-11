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

# Billing Monitor
resource "google_clouddeploy_delivery_pipeline" "billing_monitor" {
  location    = "asia-northeast1"
  name        = "billing-monitor-job-pipeline"
  description = "Delivery pipeline for billing-monitor Cloud Run Job"

  serial_pipeline {
    stages {
      target_id = google_clouddeploy_target.billing_monitor.name
    }
  }
}

resource "google_clouddeploy_target" "billing_monitor" {
  location    = "asia-northeast1"
  name        = "billing-monitor-job-target"
  description = "Target for billing-monitor Cloud Run Job"
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

resource "google_clouddeploy_delivery_pipeline" "ai_reporter" {
  location = "asia-northeast1"
  name     = "ai-reporter-job-pipeline"
  description = "Delivery pipeline for ai-reporter Cloud Run Job"

  serial_pipeline {
    stages {
      target_id = google_clouddeploy_target.ai_reporter.name
    }
  }
}

resource "google_clouddeploy_target" "ai_reporter" {
  location = "asia-northeast1"
  name     = "ai-reporter-job-target"
  description = "Target for ai-reporter Cloud Run Job"
  execution_configs {
    usages          = ["RENDER", "DEPLOY"]
    service_account = google_service_account.clouddeploy.email
  }
  run {
    location = "projects/${data.google_project.main.project_id}/locations/asia-northeast1"
  }
}

# AI Sensei Daily Poster
resource "google_clouddeploy_delivery_pipeline" "ai_sensei_daily_poster" {
  location    = "asia-northeast1"
  name        = "ai-sensei-daily-poster-job-pipeline"
  description = "Delivery pipeline for ai-sensei-daily-poster Cloud Run Job"

  serial_pipeline {
    stages {
      target_id = google_clouddeploy_target.ai_sensei_daily_poster.name
    }
  }
}

resource "google_clouddeploy_target" "ai_sensei_daily_poster" {
  location    = "asia-northeast1"
  name        = "ai-sensei-daily-poster-job-target"
  description = "Target for ai-sensei-daily-poster Cloud Run Job"
  execution_configs {
    usages          = ["RENDER", "DEPLOY"]
    service_account = google_service_account.clouddeploy.email
  }
  run {
    location = "projects/${data.google_project.main.project_id}/locations/asia-northeast1"
  }
}

# AI Sensei Event Handler
resource "google_clouddeploy_delivery_pipeline" "ai_sensei_event_handler" {
  location    = "asia-northeast1"
  name        = "ai-sensei-event-handler-pipeline"
  description = "Delivery pipeline for ai-sensei-event-handler Cloud Run Service"

  serial_pipeline {
    stages {
      target_id = google_clouddeploy_target.ai_sensei_event_handler.name
    }
  }
}

resource "google_clouddeploy_target" "ai_sensei_event_handler" {
  location    = "asia-northeast1"
  name        = "ai-sensei-event-handler-target"
  description = "Target for ai-sensei-event-handler Cloud Run Service"
  execution_configs {
    usages          = ["RENDER", "DEPLOY"]
    service_account = google_service_account.clouddeploy.email
  }
  run {
    location = "projects/${data.google_project.main.project_id}/locations/asia-northeast1"
  }
}

resource "google_clouddeploy_delivery_pipeline" "common_api" {
  location    = "asia-northeast1"
  name        = "common-api-pipeline"
  description = "Delivery pipeline for common-api Cloud Run Service"

  serial_pipeline {
    stages {
      target_id = google_clouddeploy_target.common_api.name
    }
  }
}

resource "google_clouddeploy_target" "common_api" {
  location    = "asia-northeast1"
  name        = "common-api-target"
  description = "Target for common-api Cloud Run Service"
  execution_configs {
    usages          = ["RENDER", "DEPLOY"]
    service_account = google_service_account.clouddeploy.email
  }
  run {
    location = "projects/${data.google_project.main.project_id}/locations/asia-northeast1"
  }
}
