resource "google_cloud_scheduler_job" "activity_analyzer" {
  name        = "activity-analyzer"
  description = "Analyze unused service account"
  project     = google_project.org_system.project_id
  region      = "asia-northeast1"
  schedule    = "0 0 * * 1"
  time_zone   = "Asia/Tokyo"
  pubsub_target {
    topic_name = google_pubsub_topic.activity_analyzer.id
    data       = base64encode("data")
  }
}

resource "google_cloud_scheduler_job" "mitene_downloader" {
  name        = "mitene-downloader"
  description = "Download photo from mitene and upload to cloud storage"
  project     = google_project.org_system.project_id
  region      = "asia-northeast1"
  schedule    = "0 0 * * *"
  time_zone   = "Asia/Tokyo"
  pubsub_target {
    topic_name = google_pubsub_topic.mitene_downloader.id
    data       = base64encode("data")
  }
}