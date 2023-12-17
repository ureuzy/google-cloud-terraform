resource "google_cloud_scheduler_job" "activity_analyzer" {
  name        = "activity-analyzer"
  description = "Analyze unused service account"
  project     = google_project.org_system.project_id
  region      = "asia-northeast1"
  schedule    = "0 0 * * *"
  time_zone   = "Asia/Tokyo"
  pubsub_target {
    topic_name = google_pubsub_topic.activity_analyzer.id
    data       = base64encode("data")
  }
}

resource "google_pubsub_topic" "activity_analyzer" {
  name         = "activity-analyzer"
  project      = google_project.org_system.project_id
  kms_key_name = google_kms_crypto_key.pubsub_key.id
  depends_on   = [google_kms_crypto_key_iam_member.crypto_key]
}

resource "google_eventarc_trigger" "activity_analyzer" {
  project  = google_project.org_system.project_id
  name     = "activity-analyzer"
  location = "asia-northeast1"
  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }
  destination {
    cloud_run_service {
      path    = "/"
      region  = "asia-northeast1"
      service = "activity-analyzer"
    }
  }
  transport {
    pubsub {
      topic = google_pubsub_topic.activity_analyzer.id
    }
  }
  timeouts {}
  service_account = google_service_account.eventarc.email
}