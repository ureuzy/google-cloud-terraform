resource "google_storage_bucket" "photos" {
  name                        = "ureuzy-family-photos"
  location                    = "ASIA"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  versioning {
    enabled = true
  }

  # コンソール (Flutter Web) が署名付き URL の画像を fetch で読むため。
  # アクセスは署名で制御しているので、オリジンは絞らない
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD"]
    response_header = ["Content-Type", "Content-Length", "Range"]
    max_age_seconds = 3600
  }

  # 写真の AI加工 (ai-edits/)。「破棄」「削除」した画像が古い版として残らないよう、古い版は 1 日で消す
  # (common-api も消すときに古い版まで消しているので、これは消し忘れたとき用)
  lifecycle_rule {
    condition {
      days_since_noncurrent_time = 1
      matches_prefix             = ["ai-edits/"]
    }
    action {
      type = "Delete"
    }
  }

  # 加工した直後の画像は、保存も破棄もされなければ 1 日で消す
  lifecycle_rule {
    condition {
      age            = 1
      matches_prefix = ["ai-edits/pending/"]
    }
    action {
      type = "Delete"
    }
  }
}

# おでかけ提案のデータの置き場所
# - places/   AI が調べた入場料・駐車場料金など。料金は変わるので 30 日で消し、次に提案するときに調べ直す
# - settings.json  家族構成とジャンル (画面から編集する)。消さない
resource "google_storage_bucket" "odekake_cache" {
  name                        = "ureuzy-odekake-cache"
  location                    = "ASIA-NORTHEAST1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  lifecycle_rule {
    condition {
      age            = 30
      matches_prefix = ["places/"]
    }
    action {
      type = "Delete"
    }
  }
}
