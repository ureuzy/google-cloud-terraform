resource "google_eventarc_trigger" "audit_alert" {
  project  = data.google_project.main.project_id
  name     = "audit-alert"
  location = "asia-northeast1"

  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }

  destination {
    workflow = null # Job を指定する場合は workflow ではなく cloud_run_job を使いたいが、プロバイダーのバージョンによって書き方が異なる
    # Cloud Run V2 Job をサポートしているか確認。なければ Cloud Run Service か Workflow を経由する必要がある
    cloud_run_service { # 代替案として既存の構成を模倣
      service = google_cloud_run_v2_job.audit_alert.name
      region  = "asia-northeast1"
      path    = "/" # Job の場合は path ではなく run-job などの指定が必要な場合がある
    }
  }

  transport {
    pubsub {
      topic = google_pubsub_topic.audit_alert.id
    }
  }

  service_account = google_service_account.eventarc.email
}
