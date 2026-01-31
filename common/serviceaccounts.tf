resource "google_service_account" "mitene_downloader" {
  account_id   = "mitene-downloader"
  display_name = "mitene-downloader"
  description  = "Service Account for mitene downloader Cloud Run Job"
}

resource "google_service_account" "cloudbuild" {
  account_id   = "cloudbuild"
  display_name = "Cloud Build Service Account"
  description  = "Custom Service Account for Cloud Build triggers"
}

resource "google_service_account" "clouddeploy" {
  account_id   = "clouddeploy"
  display_name = "Cloud Deploy Execution Service Account"
  description  = "Custom Service Account for Cloud Deploy operations"
}
