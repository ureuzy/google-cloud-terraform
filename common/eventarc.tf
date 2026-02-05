resource "google_eventarc_trigger" "audit_alert" {
  project  = data.google_project.main.project_id
  name     = "audit-alert"
  location = "asia-northeast1"

  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }

  destination {
    cloud_run_service {
      service = google_cloud_run_v2_service.audit_alert.name
      region  = "asia-northeast1"
    }
  }

  transport {
    pubsub {
      topic = google_pubsub_topic.audit_alert.id
    }
  }

  service_account = google_service_account.eventarc.email
}
