# バケットの使い分け (何をどこに置くか) は cloud_functions の STORAGE.md に書いてある。足すときはそちらも直す
# - ureuzy-family-photos  写真・動画・画像だけ
# - ureuzy-family-data    消えたら困るデータ (家族が入れたもの、夜の Job の結果、設定)
# - ureuzy-cache          消えても作り直せるもの

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

}

# 消えたら困るデータ (家族が入れたもの・直したもの、夜の Job の結果、設定、Job の受け渡し)。
# 写真のバケットと分け、Cloud Run と同じ東京に置く (読むのが速く、操作の料金も安い)。
# 書き直すたびに古い版ができるので 7 日で消す (それまでは間違えて書き換えても戻せる)
resource "google_storage_bucket" "data" {
  name                        = "ureuzy-family-data"
  location                    = "ASIA-NORTHEAST1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      days_since_noncurrent_time = 7
    }
    action {
      type = "Delete"
    }
  }

  # 写真の取り込みと解析のワークフローの、Job ごとの結果 (Slack に送ったあとは見返すだけ)
  lifecycle_rule {
    condition {
      age            = 7
      matches_prefix = ["photo-pipeline/"]
    }
    action {
      type = "Delete"
    }
  }
}

# 消えても作り直せるもの (外の API の答え、集計、計算を速くするためのもの)。古い版は残さない
# - places/  AI が調べた入場料・駐車場料金など。料金は変わるので 30 日で消し、次に提案するときに調べ直す
resource "google_storage_bucket" "cache" {
  name                        = "ureuzy-cache"
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

# 写真を小さくして配る Cloudflare Worker (cloud_functions の photo-cdn) が、写真のバケットを読むための HMAC キー。
# Cloudflare から Google Cloud には Workload Identity Federation で入れないので、サービスアカウントの鍵を作らない決まりの例外として、
# 読むだけ・写真の場所だけに絞ったサービスアカウント (photo-cdn) の HMAC キーにする (iam.tf の photo_cdn_photos)。
# 値は Secret Manager に入れ、Cloud Build が Worker をデプロイするときに Worker の秘密の値にする
resource "google_storage_hmac_key" "photo_cdn" {
  service_account_email = google_service_account.service_accounts["photo-cdn"].email
}

resource "google_secret_manager_secret_version" "photo_cdn_gcs_hmac" {
  secret = google_secret_manager_secret.secrets["photo-cdn-gcs-hmac"].id
  secret_data = jsonencode({
    access_id = google_storage_hmac_key.photo_cdn.access_id
    secret    = google_storage_hmac_key.photo_cdn.secret
  })
}
