# 写真の取り込みと解析のワークフロー (みてねの取り込み → 写っているもの・顔) を毎日 0:00 に起こす。
# 前は mitene-downloader (0:00)・photo-tagger と face-indexer (1:00) をそれぞれ時刻で動かしていた。3 つの Job はワークフローからだけ動く。
# photo-tagger は 1 回で Workers AI の無料枠 (1 日 10,000 ニューロン) に収まる枚数まで見る (枚数は photo-tagger の job.yaml)
resource "google_cloud_scheduler_job" "photo_pipeline" {
  name        = "photo-pipeline"
  description = "Trigger the photo-pipeline workflow"
  region      = "asia-northeast1"
  schedule    = "0 0 * * *"
  time_zone   = "Asia/Tokyo"

  http_target {
    uri         = "https://workflowexecutions.googleapis.com/v1/${google_workflows_workflow.photo_pipeline.id}/executions"
    http_method = "POST"

    oauth_token {
      service_account_email = google_service_account.service_accounts["photo-pipeline"].email
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
  # 止めている (google プロバイダ 8.4.0 から、書かないと「止めていない」になり、apply のたびに動き出す)
  paused = true

  http_target {
    http_method = "POST"
    uri         = "https://asia-northeast1-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${data.google_project.main.project_id}/jobs/ai-sensei-daily-poster:run"

    oauth_token {
      service_account_email = google_service_account.service_accounts["ai-sensei"].email
    }
  }
}
# 注: Cloud Run Job の起動には 'roles/run.developer' または 'roles/run.invoker' などの権限が SA に必要です。
