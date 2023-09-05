resource "google_service_account" "gha_workload_identity" {
  project      = google_project.org_system.project_id
  account_id   = "gha-account"
  display_name = "GitHub Actions"
}

resource "google_service_account" "eventarc" {
  project      = google_project.org_system.project_id
  account_id   = "eventarc"
  display_name = "Eventarc Trigger"
}