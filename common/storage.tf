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