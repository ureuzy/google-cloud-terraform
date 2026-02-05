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
      service_account_email = google_service_account.mitene_downloader.email
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
      service_account_email = google_service_account.activity_analyzer.email
    }
  }
}
# 注: Cloud Run Job の起動には 'roles/run.developer' または 'roles/run.invoker' などの権限が SA に必要です。
