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
}

# おでかけ提案で AI が調べた入場料・駐車場料金などの置き場所
# 料金は変わるので 30 日で消し、次に提案するときに調べ直す
resource "google_storage_bucket" "odekake_cache" {
  name                        = "ureuzy-odekake-cache"
  location                    = "ASIA-NORTHEAST1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = true

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}
