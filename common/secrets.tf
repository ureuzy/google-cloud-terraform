locals {
  secrets = [
    "slack-webhook",
    "slack-ai-bot",
    "slack-sensei-bot",
    "slack-sensei-signing-secret",
    "mitene-url",
    "claude-sensei-secret",
  ]
}

resource "google_secret_manager_secret" "secrets" {
  for_each  = toset(local.secrets)
  secret_id = each.value
  replication {
    auto {}
  }
}
