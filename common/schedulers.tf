resource "google_cloud_scheduler_job" "mitene_downloader" {
  name        = "mitene-downloader"
  description = "Trigger mitene-downloader Cloud Run Job"
  region      = "asia-northeast1"
  schedule    = "0 0 * * *"
  time_zone   = "Asia/Tokyo"

  http_target {
    uri         = "https://asia-northeast1-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${data.google_project.main.project_id}/jobs/mitene-downloader:run"
    http_method = "POST"

    oauth_token {
      service_account_email = google_service_account.service_accounts["mitene-downloader"].email
    }
  }
}

# 写真の中身を見るのは毎日 1 回、mitene-downloader (0:00) が新しい写真を取り込んだあと。
# 1 回で Workers AI の無料枠 (1 日 10,000 ニューロン) に収まる枚数まで見る (枚数は photo-tagger の job.yaml)
resource "google_cloud_scheduler_job" "photo_tagger" {
  name        = "photo-tagger"
  description = "Trigger photo-tagger Cloud Run Job"
  region      = "asia-northeast1"
  schedule    = "0 1 * * *"
  time_zone   = "Asia/Tokyo"

  http_target {
    uri         = "https://asia-northeast1-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${data.google_project.main.project_id}/jobs/photo-tagger:run"
    http_method = "POST"

    oauth_token {
      service_account_email = google_service_account.service_accounts["photo-tagger"].email
    }
  }
}

resource "google_cloud_scheduler_job" "billing_monitor" {
  name        = "billing-monitor"
  description = "Trigger billing-monitor Cloud Run Job"
  region      = "asia-northeast1"
  schedule    = "0 0 * * *"
  time_zone   = "Asia/Tokyo"

  http_target {
    uri         = "https://asia-northeast1-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${data.google_project.main.project_id}/jobs/billing-monitor:run"
    http_method = "POST"

    oauth_token {
      service_account_email = google_service_account.service_accounts["billing-monitor"].email
    }
  }
}

resource "google_cloud_scheduler_job" "activity_analyzer" {
  name        = "activity-analyzer"
  description = "Trigger activity-analyzer Cloud Run Job"
  region      = "asia-northeast1"
  schedule    = "0 0 * * 1"
  time_zone   = "Asia/Tokyo"

  http_target {
    uri         = "https://asia-northeast1-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${data.google_project.main.project_id}/jobs/activity-analyzer:run"
    http_method = "POST"

    oauth_token {
      service_account_email = google_service_account.service_accounts["activity-analyzer"].email
    }
  }
}

resource "google_cloud_scheduler_job" "ai_reporter" {
  name        = "ai-reporter"
  description = "Trigger ai-reporter Cloud Run Job"
  region      = "asia-northeast1"
  schedule    = "0 0 * * *"
  time_zone   = "Asia/Tokyo"

  http_target {
    http_method = "POST"
    uri         = "https://asia-northeast1-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${data.google_project.main.project_id}/jobs/ai-reporter:run"

    oauth_token {
      service_account_email = google_service_account.service_accounts["ai-reporter"].email
    }
  }
}

resource "google_cloud_scheduler_job" "ai_sensei_daily_poster" {
  name        = "ai-sensei-daily-poster"
  description = "Trigger ai-sensei-daily-poster Cloud Run Job"
  region      = "asia-northeast1"
  schedule    = "0 9 * * *"
  time_zone   = "Asia/Tokyo"

  http_target {
    http_method = "POST"
    uri         = "https://asia-northeast1-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${data.google_project.main.project_id}/jobs/ai-sensei-daily-poster:run"

    oauth_token {
      service_account_email = google_service_account.service_accounts["ai-sensei"].email
    }
  }
}
# 注: Cloud Run Job の起動には 'roles/run.developer' または 'roles/run.invoker' などの権限が SA に必要です。
