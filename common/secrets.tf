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
    # 写真を小さくして配る Cloudflare Worker (cloud_functions の photo-cdn)。
    # - photo-cdn-gcs-hmac: Worker が写真のバケットを読む HMAC キー (terraform が作って入れる。storage.tf)
    # - photo-cdn-signing-key: common-api が写真の URL に付ける署名の鍵。Worker が確かめる (terraform が作って入れる)
    # - cloudflare-photo-cdn-token: Cloud Build が Worker をデプロイする Cloudflare のトークン (cloudflare-terraform で作り、値は terraform output から入れる)
    "photo-cdn-gcs-hmac",
    "photo-cdn-signing-key",
    "cloudflare-photo-cdn-token",
    # 家族が入れ直した元の動画を置く Cloudflare R2 のバケット (ureuzy-family-originals) を、common-api が S3 互換の API で読み書きする鍵。
    # cloudflare-terraform で作り、値は terraform output から入れる (cloud_functions の STORAGE.md)
    "r2-originals-access-key-id",
    "r2-originals-secret-access-key",
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

# common-api が写真の URL に付ける署名 (HMAC-SHA256) の鍵。Worker (photo-cdn) と common-api だけが読む
resource "random_password" "photo_cdn_signing_key" {
  length  = 64
  special = false
}

resource "google_secret_manager_secret_version" "photo_cdn_signing_key" {
  secret      = google_secret_manager_secret.secrets["photo-cdn-signing-key"].id
  secret_data = random_password.photo_cdn_signing_key.result
}
