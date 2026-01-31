resource "google_secret_manager_secret" "slack_webhook" {
  secret_id = "slack-webhook"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "mitene_url" {
  secret_id = "mitene-url"
  replication {
    auto {}
  }
}

