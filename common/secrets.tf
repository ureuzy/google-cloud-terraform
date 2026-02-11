resource "google_secret_manager_secret" "slack_webhook" {
  secret_id = "slack-webhook"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "slack_ai_bot" {
  secret_id = "slack-ai-bot"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "slack_sensei_bot" {
  secret_id = "slack-sensei-bot"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "slack_sensei_signing_secret" {
  secret_id = "slack-sensei-signing-secret"
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

