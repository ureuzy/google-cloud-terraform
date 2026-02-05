resource "google_pubsub_topic" "audit_alert" {
  name    = "audit-alert"
  project = data.google_project.main.project_id
}
