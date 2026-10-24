locals {
  secrets = [
    "slack-webhook",
    "slack-ai-bot",
    "slack-sensei-bot",
    "slack-sensei-signing-secret",
    "mitene-url",
    # みてねの共有ページのパスワード (2026-09 から必須。値は gcloud で入れる。cloud_functions の mitene-downloader)
    "mitene-password",
    # Google AI Studio の Gemini API の無料枠のキー (common-api で、家族が無料枠を選んだ AI の機能で使う。値は gcloud で入れる)
    "gemini-free-api-key",
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

# mitene-password は先に gcloud で作ったので、terraform に取り込む (入っている版はそのまま)
import {
  id = "projects/ureuzy-common/secrets/mitene-password"
  to = google_secret_manager_secret.secrets["mitene-password"]
}
