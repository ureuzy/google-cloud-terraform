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

  # コンソール (Flutter Web) が署名付き URL の画像を fetch で読み、アップロードするファイルを PUT するため。
  # アクセスは署名で制御しているので、オリジンは絞らない
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT"]
    response_header = ["Content-Type", "Content-Length", "Range"]
    max_age_seconds = 3600
  }

  # 画面から消した写真 (みてね・アップロード) は古い版として残るので、30 日たったら消す。
  # それまでは間違えて消しても GCS から戻せる
  lifecycle_rule {
    condition {
      days_since_noncurrent_time = 30
      matches_prefix             = ["mitene/", "mitene-thumbs/", "uploads/", "uploads-thumbs/"]
    }
    action {
      type = "Delete"
    }
  }

  # アップロードの途中で止まったファイル (受け取り前) は 1 日で消す
  lifecycle_rule {
    condition {
      age            = 1
      matches_prefix = ["uploads/incoming/"]
    }
    action {
      type = "Delete"
    }
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

  # 行った場所 (photo-places/)・行きたいリスト (wishlist/)。書き直すたびに古い版ができるので 7 日で消す (それまでは間違えて書き換えても戻せる)
  lifecycle_rule {
    condition {
      days_since_noncurrent_time = 7
      matches_prefix             = ["photo-places/", "wishlist/"]
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
