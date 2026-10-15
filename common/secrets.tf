locals {
  secrets = [
    "slack-webhook",
    "slack-ai-bot",
    "slack-sensei-bot",
    "slack-sensei-signing-secret",
    "mitene-url",
    "claude-sensei-secret",
    "youtube-api-key",
    # べんりの Netflix のコード: Gmail の Apps Script の URL と合言葉 (値は gcloud で入れる。cloud_functions の common-api/tools/netflix)
    "netflix-script-url",
    "netflix-script-key",
  ]
}

resource "google_secret_manager_secret" "secrets" {
  for_each  = toset(local.secrets)
  secret_id = each.value
  replication {
    auto {}
  }
}
