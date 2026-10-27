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
    # アプリの地図 (Mapbox) の公開用トークン。common-api がログインした家族にだけ返す (値は gcloud で入れる)
    "mapbox-token",
    # photo-tagger が写真の中身を見てもらう Cloudflare Workers AI のトークン (cloudflare-terraform で作り、値は terraform output から入れる)
    "cloudflare-workers-ai-token",
    # common-api の「外部サービスの使用量」で Workers AI の使用量を読む Cloudflare のトークン (cloudflare-terraform で作り、値は terraform output から入れる)
    "cloudflare-analytics-token",
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
