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

resource "google_eventarc_trigger" "audit_alert" {
  project  = google_project.org_system.project_id
  name     = "audit-alert"
  location = "asia-northeast1"
  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }
  destination {
    cloud_run_service {
      path    = "/"
      region  = "asia-northeast1"
      service = "audit-alert"
    }
  }
  transport {
    pubsub {
      topic = google_pubsub_topic.audit_alert.id
    }
  }
  timeouts {}
  service_account = google_service_account.eventarc.email
}

resource "google_eventarc_trigger" "mitene_downloader" {
  project  = google_project.org_system.project_id
  name     = "mitene-downloader"
  location = "asia-northeast1"
  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }
  destination {
    cloud_run_service {
      path    = "/"
      region  = "asia-northeast1"
      service = "mitene-downloader"
    }
  }
  transport {
    pubsub {
      topic = google_pubsub_topic.mitene_downloader.id
    }
  }
  timeouts {}
  service_account = google_service_account.eventarc.email
}