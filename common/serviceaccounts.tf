resource "google_service_account" "mitene_downloader" {
  project      = data.google_project.main.project_id
  account_id   = "mitene-downloader"
  display_name = "mitene-downloader"
  description  = "Service Account for mitene downloader Cloud Run Job"
}