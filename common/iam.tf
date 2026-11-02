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

# For photo-pipeline SA Permissions
# 写真の取り込みと解析のワークフローの実行と、それを 0:00 に起こす Scheduler に使う。
# - run.invoker: 3 つの Job を動かす (run.jobs.run)
# - run.viewer: Job が終わるまで待つ (動かしたときの長い処理を読む run.operations.get)
# - workflows.invoker: Scheduler がワークフローを起こす
# - logging.logWriter: 失敗したステップをログに残す (call_log_level)
# - run.jobsExecutorWithOverrides: Job に結果を書く場所 (環境変数 REPORT_OBJECT) を渡して動かす
resource "google_project_iam_member" "photo_pipeline" {
  for_each = toset([
    "roles/run.invoker",
    "roles/run.viewer",
    "roles/run.jobsExecutorWithOverrides",
    "roles/workflows.invoker",
    "roles/logging.logWriter",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_accounts["photo-pipeline"].email}"
}

# 3 つの Job の結果を、1 つの投稿とスレッドにまとめて Slack に送る (billing-monitor と同じボット。Webhook ではスレッドに返信できない)
resource "google_secret_manager_secret_iam_member" "photo_pipeline_slack" {
  secret_id = google_secret_manager_secret.secrets["slack-ai-bot"].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.service_accounts["photo-pipeline"].email}"
}

# photo-tagger: 写真のサムネイルを読み、写っているもの (タグ・説明) を photo-tags/ に書く。結果は Slack に知らせる
resource "google_project_iam_member" "photo_tagger" {
  for_each = toset([
    "roles/run.invoker",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_accounts["photo-tagger"].email}"
}

resource "google_storage_bucket_iam_member" "photo_tagger_read" {
  bucket = google_storage_bucket.photos.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.service_accounts["photo-tagger"].email}"
}

resource "google_storage_bucket_iam_member" "photo_tagger_write" {
  bucket = google_storage_bucket.photos.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.service_accounts["photo-tagger"].email}"

  condition {
    title       = "photo tags"
    description = "写真に写っているもの (photo-tags/) だけを書き込める"
    expression  = "resource.name.startsWith(\"projects/_/buckets/${google_storage_bucket.photos.name}/objects/photo-tags/\")"
  }
}

# Workers AI のトークンと、結果を Slack に知らせる webhook (mitene-downloader と同じ)
resource "google_secret_manager_secret_iam_member" "photo_tagger_secrets" {
  for_each = toset([
    google_secret_manager_secret.secrets["cloudflare-workers-ai-token"].secret_id,
    google_secret_manager_secret.secrets["slack-webhook"].secret_id,
  ])
  secret_id = each.value
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.service_accounts["photo-tagger"].email}"
}

# face-indexer: 写真を読み、見つけた顔 (数字の並びと切り抜き) を faces/ に書く。結果は Slack に知らせる
resource "google_project_iam_member" "face_indexer" {
  for_each = toset([
    "roles/run.invoker",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_accounts["face-indexer"].email}"
}

resource "google_storage_bucket_iam_member" "face_indexer_read" {
  bucket = google_storage_bucket.photos.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.service_accounts["face-indexer"].email}"
}

resource "google_storage_bucket_iam_member" "face_indexer_write" {
  bucket = google_storage_bucket.photos.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.service_accounts["face-indexer"].email}"

  condition {
    title       = "faces"
    description = "写真の顔 (faces/) だけを書き込める"
    expression  = "resource.name.startsWith(\"projects/_/buckets/${google_storage_bucket.photos.name}/objects/faces/\")"
  }
}

resource "google_secret_manager_secret_iam_member" "face_indexer_slack" {
  secret_id = google_secret_manager_secret.secrets["slack-webhook"].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.service_accounts["face-indexer"].email}"
}

# growth-video: 写っている人の成長の動画を作る (common-api が動かす)。写真を読み、動画と進み具合を growth/ に書く
resource "google_storage_bucket_iam_member" "growth_video_read" {
  bucket = google_storage_bucket.photos.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.service_accounts["growth-video"].email}"
}

resource "google_storage_bucket_iam_member" "growth_video_write" {
  bucket = google_storage_bucket.photos.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.service_accounts["growth-video"].email}"

  condition {
    title       = "growth"
    description = "成長の動画 (growth/) だけを書き込める"
    expression  = "resource.name.startsWith(\"projects/_/buckets/${google_storage_bucket.photos.name}/objects/growth/\")"
  }
}

# common-api が growth-video を動かす (アプリで「成長の動画を作る」を押したとき、作る動画の ID を GROWTH_ID で渡す)。
# Job は Cloud Deploy が作るので、Job ができてから、その Job にだけ付ける
resource "google_cloud_run_v2_job_iam_member" "common_api_growth_video" {
  project  = data.google_project.main.project_id
  location = "asia-northeast1"
  name     = "growth-video"
  role     = "roles/run.jobsExecutorWithOverrides"
  member   = "serviceAccount:${google_service_account.service_accounts["common-api"].email}"
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
    google_secret_manager_secret.secrets["mitene-password"].secret_id,
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
# cloudtrace.agent: どの API のどこに時間がかかっているかを Cloud Trace に送るため (OpenTelemetry)
resource "google_project_iam_member" "common_api" {
  for_each = toset([
    "roles/run.invoker",
    "roles/viewer",
    "roles/cloudscheduler.admin",
    "roles/cloudtrace.agent",
    # アプリのシステム管理から、写真の取り込みと解析のワークフローを動かす (見るのは roles/viewer で足りる)
    "roles/workflows.invoker",
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
# - photo-places/                 行った場所 (写真の位置から調べた施設名・家族が直した名前)
# - wishlist/                     行きたいリスト (Google マップの保存済みリストから取り込んだ場所と、家族が足した場所)
# - photo-tags/                   写真に写っているもの (photo-tagger が書く。家族が違うタグを消す)
# - faces/                        写真の顔 (face-indexer が書く。家族が教えた顔・知らない人)
# - growth/                       成長の動画 (作る内容を置き、growth-video が動画を書く。消す・フォトに入れる)
locals {
  common_api_photo_write_prefixes = ["ai-edits/", "uploads/", "uploads-thumbs/", "mitene/", "mitene-thumbs/", "photo-deletions/", "photo-places/", "wishlist/", "photo-tags/", "faces/", "growth/"]
}

resource "google_storage_bucket_iam_member" "common_api_photos_ai_edits" {
  bucket = google_storage_bucket.photos.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.service_accounts["common-api"].email}"

  condition {
    title       = "console writes"
    description = "AI加工・アップロード・削除・行った場所・行きたいリストで使う場所だけを書き込み・削除できる"
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

resource "google_secret_manager_secret_iam_member" "common_api_netflix" {
  for_each  = toset(["netflix-script-url", "netflix-script-key", "gemini-free-api-key", "mapbox-token", "cloudflare-analytics-token"])
  secret_id = google_secret_manager_secret.secrets[each.value].secret_id
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


# データのバケット (ureuzy-family-data) とキャッシュのバケット (ureuzy-cache) の権限。
# Job は、書く場所 (フォルダ) だけに絞る。一覧を取る (objects.list) のはバケットに対する操作なので、一覧が要る Job はバケットそのものも条件に入れる
locals {
  data_objects = "projects/_/buckets/${google_storage_bucket.data.name}/objects/"
  # Job ごとに読み書きできる場所。photo-pipeline/ はワークフローに渡す結果 (Job の名前のファイル)
  data_job_writes = {
    "mitene-downloader" = ["photo-index/", "photo-pipeline/"]
    "photo-tagger"      = ["photo-tags/", "photo-pipeline/"]
    "face-indexer"      = ["faces/index.json", "photo-pipeline/"]
    "growth-video"      = ["growth/"]
  }
}

resource "google_storage_bucket_iam_member" "common_api_data" {
  bucket = google_storage_bucket.data.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.service_accounts["common-api"].email}"
}

resource "google_storage_bucket_iam_member" "common_api_cache" {
  bucket = google_storage_bucket.cache.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.service_accounts["common-api"].email}"
}

resource "google_storage_bucket_iam_member" "jobs_data_write" {
  for_each = local.data_job_writes
  bucket   = google_storage_bucket.data.name
  role     = "roles/storage.objectUser"
  member   = "serviceAccount:${google_service_account.service_accounts[each.key].email}"
  condition {
    title       = "${each.key} data"
    description = "${join(", ", each.value)} だけを読み書きできる"
    expression = join(" || ", [
      for p in each.value : "resource.name.startsWith(\"${local.data_objects}${p}\")"
    ])
  }
}

# mitene-downloader は、画面から消した写真の印 (photo-deletions/) の一覧を読んで、取り直さないようにする
resource "google_storage_bucket_iam_member" "mitene_downloader_data_deletions" {
  bucket = google_storage_bucket.data.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.service_accounts["mitene-downloader"].email}"
  condition {
    title       = "photo deletions"
    description = "消した写真の印 (photo-deletions/) の一覧と中身だけを読める"
    expression  = "resource.name == \"projects/_/buckets/${google_storage_bucket.data.name}\" || resource.name.startsWith(\"${local.data_objects}photo-deletions/\")"
  }
}

# ワークフローは、各 Job が書いた結果 (photo-pipeline/) を読んで Slack に送る
resource "google_storage_bucket_iam_member" "photo_pipeline_data" {
  bucket = google_storage_bucket.data.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.service_accounts["photo-pipeline"].email}"
  condition {
    title       = "photo pipeline reports"
    description = "Job の結果 (photo-pipeline/) だけを読める"
    expression  = "resource.name.startsWith(\"${local.data_objects}photo-pipeline/\")"
  }
}
