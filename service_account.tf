resource "google_service_account" "eventarc" {
  project      = google_project.org_system.project_id
  account_id   = "eventarc"
  display_name = "Eventarc Trigger"
}

resource "google_service_account" "audit_alert_functions" {
  project      = google_project.org_system.project_id
  account_id   = "audit-alert-functions"
  display_name = "audit-alert-functions"
  description  = "Service Account for Audit alert functions"
}

resource "google_service_account" "activity_analyzer" {
  project      = google_project.org_system.project_id
  account_id   = "activity-analyzer"
  display_name = "activity-analyzer"
  description  = "Analyze unused service account"
}

resource "google_service_account" "mitene_downloader" {
  project      = google_project.org_system.project_id
  account_id   = "mitene-downloader"
  display_name = "mitene-downloader"
  description  = "Service Account for mitene downloader"
}

resource "google_service_account" "role_recommender" {
  project      = google_project.org_system.project_id
  account_id   = "role-recommender"
  display_name = "role-recommender"
  description  = "role-recommender"
}

### Workload Identity User for GitHub Actions
resource "google_service_account" "gha" {
  project      = google_project.org_system.project_id
  account_id   = "gha-account"
  display_name = "Github Actions"
  description  = "Github Actions"
}