resource "google_pubsub_topic" "audit_alert" {
  name    = "audit-alert"
  project = data.google_project.main.project_id
}

data "google_cloud_run_v2_service" "audit_alert" {
  name     = "audit-alert"
  location = "asia-northeast1"
  project  = data.google_project.main.project_id
}

resource "google_pubsub_subscription" "audit_alert" {
  name  = "audit-alert"
  topic = google_pubsub_topic.audit_alert.name

  push_config {
    push_endpoint = "${data.google_cloud_run_v2_service.audit_alert.uri}/"
    oidc_token {
      service_account_email = google_service_account.audit_alert.email
    }
  }
}
