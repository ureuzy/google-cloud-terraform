resource "google_cloud_scheduler_job" "role_recommender" {
  name        = "role-recommender"
  description = "Role recommend"
  project     = google_project.org_system.project_id
  region      = "asia-northeast1"
  schedule    = "0 0 * * *"
  time_zone   = "Asia/Tokyo"
  pubsub_target {
    topic_name = google_pubsub_topic.role_recommender.id
    data       = base64encode("data")
  }
}

resource "google_pubsub_topic" "role_recommender" {
  name         = "role-recommender"
  project      = google_project.org_system.project_id
  kms_key_name = google_kms_crypto_key.pubsub_key.id
  depends_on   = [google_kms_crypto_key_iam_member.crypto_key]
}

resource "google_eventarc_trigger" "role_recommender" {
  project  = google_project.org_system.project_id
  name     = "role-recommender"
  location = "asia-northeast1"
  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }
  destination {
    cloud_run_service {
      path    = "/"
      region  = "asia-northeast1"
      service = "role-recommender"
    }
  }
  transport {
    pubsub {
      topic = google_pubsub_topic.role_recommender.id
    }
  }
  timeouts {}
  service_account = google_service_account.eventarc.email
}