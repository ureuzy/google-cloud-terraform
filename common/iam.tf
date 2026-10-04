# For CloudBuild SA Permissions
resource "google_project_iam_member" "cloudbuild" {
  for_each = toset([
    "roles/cloudbuild.builds.builder",
    "roles/iam.serviceAccountUser",
    "roles/logging.logWriter",
    "roles/clouddeploy.operator",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_accounts["cloudbuild"].email}"
}

# For Cloud Deploy execution using custom Service Account
resource "google_project_iam_member" "clouddeploy" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/clouddeploy.jobRunner",
    "roles/run.developer",
    "roles/iam.serviceAccountUser",
    "roles/artifactregistry.reader",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_accounts["clouddeploy"].email}"

}

# For mitene downloader SA Permissions
resource "google_project_iam_member" "mitene_downloader" {
  for_each = toset([
    "roles/run.invoker",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_accounts["mitene-downloader"].email}"
}

# For billing monitor SA Permissions
resource "google_project_iam_member" "billing_monitor" {
  for_each = toset([
    "roles/run.invoker",
    "roles/secretmanager.secretAccessor",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_accounts["billing-monitor"].email}"
}

resource "google_storage_bucket_iam_member" "mitene_downloader_photos" {
  bucket = google_storage_bucket.photos.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.service_accounts["mitene-downloader"].email}"
}

resource "google_secret_manager_secret_iam_member" "mitene_downloader_secrets" {
  for_each = toset([
    google_secret_manager_secret.secrets["slack-webhook"].secret_id,
    google_secret_manager_secret.secrets["mitene-url"].secret_id,
  ])
  secret_id = each.value
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.service_accounts["mitene-downloader"].email}"
}

# For Activity Analyzer SA Permissions
resource "google_project_iam_member" "activity_analyzer" {
  for_each = toset([
    "roles/run.invoker",
    "roles/secretmanager.secretAccessor",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_accounts["activity-analyzer"].email}"
}

# For Audit Alert SA Permissions
resource "google_project_iam_member" "audit_alert" {
  for_each = toset([
    "roles/run.invoker",
    "roles/secretmanager.secretAccessor",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_accounts["audit-alert"].email}"
}

# For AI Reporter SA Permissions
resource "google_project_iam_member" "ai_reporter" {
  for_each = toset([
    "roles/run.invoker",
    "roles/secretmanager.secretAccessor",
    "roles/bigquery.dataViewer",
    "roles/bigquery.user",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_accounts["ai-reporter"].email}"
}

# For AI Sensei SA Permissions
resource "google_project_iam_member" "ai_sensei" {
  for_each = toset([
    "roles/run.invoker",
    "roles/secretmanager.secretAccessor",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_accounts["ai-sensei"].email}"
}

# For common-api SA Permissions
resource "google_project_iam_member" "common_api" {
  for_each = toset([
    "roles/run.invoker",
    "roles/viewer",
    "roles/cloudscheduler.admin",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_accounts["common-api"].email}"
}

# common-api が写真の一覧と署名付き URL を返すため
resource "google_storage_bucket_iam_member" "common_api_photos" {
  bucket = google_storage_bucket.photos.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.service_accounts["common-api"].email}"
}

# common-api が写真のバケットに書き込む・消す場所
# - ai-edits/                     写真の AI加工
# - uploads/, uploads-thumbs/     画面からアップロードした写真とサムネイル
# - mitene/, mitene-thumbs/       画面から消すとき (書き込みは mitene-downloader だけがする)
# - photo-deletions/              消したみてねの写真の印 (mitene-downloader が取り直さないように)
locals {
  common_api_photo_write_prefixes = ["ai-edits/", "uploads/", "uploads-thumbs/", "mitene/", "mitene-thumbs/", "photo-deletions/"]
}

resource "google_storage_bucket_iam_member" "common_api_photos_ai_edits" {
  bucket = google_storage_bucket.photos.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.service_accounts["common-api"].email}"

  condition {
    title       = "console writes"
    description = "AI加工・アップロード・削除で使う場所だけを書き込み・削除できる"
    expression = join(" || ", [
      for p in local.common_api_photo_write_prefixes :
      "resource.name.startsWith(\"projects/_/buckets/${google_storage_bucket.photos.name}/objects/${p}\")"
    ])
  }
}

# 鍵ファイルを持たずに署名付き URL を作るため、自身の SA で signBlob できるようにする
resource "google_service_account_iam_member" "common_api_self_token_creator" {
  service_account_id = google_service_account.service_accounts["common-api"].name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${google_service_account.service_accounts["common-api"].email}"
}

# common-api のおでかけ提案で、Places API / Routes API をサービスアカウントの OAuth で呼ぶため (API キーを持たない)
# Gemini は ureuzy-ai プロジェクトの Vertex AI を使う (ai/iam.tf)
resource "google_project_iam_member" "common_api_odekake" {
  for_each = toset([
    "roles/serviceusage.serviceUsageConsumer",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_accounts["common-api"].email}"
}

resource "google_secret_manager_secret_iam_member" "common_api_youtube_key" {
  secret_id = google_secret_manager_secret.secrets["youtube-api-key"].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.service_accounts["common-api"].email}"
}

resource "google_storage_bucket_iam_member" "common_api_odekake_cache" {
  bucket = google_storage_bucket.odekake_cache.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.service_accounts["common-api"].email}"
}

# For GKE Autopilot node SA Permissions
resource "google_project_iam_member" "gke_common" {
  for_each = toset([
    "roles/container.defaultNodeServiceAccount",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_accounts["gke-common"].email}"
}

# Allow Pub/Sub to create tokens for audit-alert SA
resource "google_service_account_iam_member" "pubsub_token_creator" {
  service_account_id = google_service_account.service_accounts["audit-alert"].name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:service-${data.google_project.main.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

# Allow public access to Cloud Run Services
resource "google_cloud_run_v2_service_iam_member" "common_api_public_access" {
  name     = google_cloud_run_v2_service.common_api.name
  location = google_cloud_run_v2_service.common_api.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_v2_service_iam_member" "ai_sensei_event_handler_public_access" {
  name     = google_cloud_run_v2_service.ai_sensei_event_handler.name
  location = google_cloud_run_v2_service.ai_sensei_event_handler.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

