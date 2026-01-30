resource "google_service_account" "mitene_downloader" {
  project      = data.google_project.main.project_id
  account_id   = "mitene-downloader"
  display_name = "mitene-downloader"
  description  = "Service Account for mitene downloader Cloud Run Job"
}

resource "google_service_account" "cloudbuild" {
  project      = data.google_project.main.project_id
  account_id   = "cloudbuild-sa"
  display_name = "Cloud Build Service Account"
  description  = "Custom Service Account for Cloud Build triggers"
}