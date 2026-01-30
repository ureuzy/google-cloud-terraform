resource "google_secret_manager_secret" "slack_webhook" {
  project   = data.google_project.main.project_id
  secret_id = "slack-webhook"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "mitene_url" {
  project   = data.google_project.main.project_id
  secret_id = "mitene-url"
  replication {
    auto {}
  }
}
