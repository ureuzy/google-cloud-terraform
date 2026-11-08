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

# photo-tagger: 写真のサムネイルを読み、写っているもの (タグ・説明) をデータのバケットの photo-tags/ に書く (権限は下の jobs_data_write)
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

# face-indexer: 写真を読み、顔の切り抜きを写真のバケットの faces/crops/ に、顔の一覧をデータのバケットの faces/index.json に書く
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
    title       = "face crops"
    description = "顔の切り抜き (faces/crops/) だけを書き込める"
    expression  = "resource.name.startsWith(\"projects/_/buckets/${google_storage_bucket.photos.name}/objects/faces/crops/\")"
  }
}

resource "google_secret_manager_secret_iam_member" "face_indexer_slack" {
  secret_id = google_secret_manager_secret.secrets["slack-webhook"].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.service_accounts["face-indexer"].email}"
}

# growth-video: 写っている人の成長の動画を作る (common-api が動かす)。写真を読み、動画を写真のバケットの growth/ に、進み具合をデータのバケットの growth/ に書く
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

# mitene-downloader は、みてねの写真とサムネイル (mitene/, mitene-thumbs/) だけを読み書きする。一覧を取るのはバケットに対する操作なので、バケットそのものも入れる
resource "google_storage_bucket_iam_member" "mitene_downloader_photos" {
  bucket = google_storage_bucket.photos.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.service_accounts["mitene-downloader"].email}"

  condition {
    title       = "mitene photos"
    description = "みてねの写真とサムネイル (mitene/, mitene-thumbs/) だけを読み書きできる"
    expression = join(" || ", concat(
      ["resource.name == \"projects/_/buckets/${google_storage_bucket.photos.name}\""],
      [for p in ["mitene/", "mitene-thumbs/"] : "resource.name.startsWith(\"projects/_/buckets/${google_storage_bucket.photos.name}/objects/${p}\")"],
    ))
  }
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

# common-api が写真のバケットに書き込む・消す場所 (写真・動画・画像だけ。データはデータのバケットに置く)
# - ai-edits/                     写真の AI加工
# - uploads/, uploads-thumbs/     画面からアップロードした写真とサムネイル
# - mitene/, mitene-thumbs/       画面から消すとき (書き込みは mitene-downloader だけがする)
# - growth/                       成長の動画 (growth-video が書く。消す・フォトに入れる)
locals {
  common_api_photo_write_prefixes = ["ai-edits/", "uploads/", "uploads-thumbs/", "mitene/", "mitene-thumbs/", "growth/"]
}

resource "google_storage_bucket_iam_member" "common_api_photos_ai_edits" {
  bucket = google_storage_bucket.photos.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.service_accounts["common-api"].email}"

  condition {
    title       = "console writes"
    description = "AI加工・アップロード・削除・成長の動画で使う場所だけを書き込み・削除できる"
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
  for_each  = toset(["netflix-script-url", "netflix-script-key", "gemini-free-api-key", "mapbox-token", "cloudflare-analytics-token", "r2-originals-access-key-id", "r2-originals-secret-access-key"])
  secret_id = google_secret_manager_secret.secrets[each.value].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.service_accounts["common-api"].email}"
}


# common-api が写真の URL に付ける署名の鍵 (photo-cdn)
resource "google_secret_manager_secret_iam_member" "common_api_photo_cdn" {
  secret_id = google_secret_manager_secret.secrets["photo-cdn-signing-key"].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.service_accounts["common-api"].email}"
}

# photo-cdn (Cloudflare Worker) が読める写真。画面に出す写真とサムネイルだけで、読むだけ (一覧も取れない)。
# アップロードの受け取り途中 (uploads/incoming/) は読ませない
locals {
  photo_cdn_read_prefixes = ["mitene/", "mitene-thumbs/", "uploads/", "uploads-thumbs/"]
}

resource "google_storage_bucket_iam_member" "photo_cdn_photos" {
  bucket = google_storage_bucket.photos.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.service_accounts["photo-cdn"].email}"

  condition {
    title       = "photos shown in the app"
    description = "Only the photos and thumbnails the app shows, not uploads in progress"
    expression = join(" && ", [
      "(${join(" || ", [for p in local.photo_cdn_read_prefixes : "resource.name.startsWith(\"projects/_/buckets/${google_storage_bucket.photos.name}/objects/${p}\")"])})",
      "!resource.name.startsWith(\"projects/_/buckets/${google_storage_bucket.photos.name}/objects/uploads/incoming/\")",
    ])
  }
}

# Cloud Build が photo-cdn (Cloudflare Worker) をデプロイするときに読む: Cloudflare のトークンと、Worker に入れる秘密の値
resource "google_secret_manager_secret_iam_member" "cloudbuild_photo_cdn" {
  for_each  = toset(["cloudflare-photo-cdn-token", "photo-cdn-gcs-hmac", "photo-cdn-signing-key"])
  secret_id = google_secret_manager_secret.secrets[each.value].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.service_accounts["cloudbuild"].email}"
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

# Cloud Build が、Go の組み立ての途中のもの (ダウンロードしたライブラリ・組み立てた結果) をキャッシュのバケットに置いて、次のビルドで使い回す。
# 置くのは build-cache/ の下だけ。消えても次のビルドが遅くなるだけ (cloud_functions の STORAGE.md)
resource "google_storage_bucket_iam_member" "cloudbuild_build_cache" {
  bucket = google_storage_bucket.cache.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.service_accounts["cloudbuild"].email}"

  condition {
    title       = "build cache"
    description = "Only the build cache under build-cache/"
    expression  = "resource.name.startsWith(\"projects/_/buckets/${google_storage_bucket.cache.name}/objects/build-cache/\")"
  }
}
