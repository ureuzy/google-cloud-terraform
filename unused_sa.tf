resource "google_cloud_scheduler_job" "search_unused_sa_job" {
  name        = "test-job"
  description = "test job"
  project     = google_project.org_system.project_id
  region      = "asia-northeast1"
  schedule    = "0 * * * *"
  time_zone   = "Asia/Tokyo"
  pubsub_target {
    topic_name = google_pubsub_topic.search_unused_sa.id
    data       = base64encode("data")
  }
}

resource "google_pubsub_topic" "search_unused_sa" {
  name         = "search_unused_sa"
  project      = google_project.org_system.project_id
  kms_key_name = google_kms_crypto_key.pubsub_key.id
  depends_on   = [google_kms_crypto_key_iam_member.crypto_key]
}

resource "google_eventarc_trigger" "search_unused_sa" {
  project  = google_project.org_system.project_id
  name     = "search-unused-sa"
  location = "asia-northeast1"
  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }
  destination {
    cloud_run_service {
      path    = "/"
      region  = "asia-northeast1"
      service = "search-unused-sa"
    }
  }
  transport {
    pubsub {
      topic = google_pubsub_topic.search_unused_sa.id
    }
  }
  timeouts {}
  service_account = google_service_account.eventarc.email
}