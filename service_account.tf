resource "google_service_account" "eventarc" {
  project      = google_project.org_system.project_id
  account_id   = "eventarc"
  display_name = "Eventarc Trigger"
}

### Workload Identity User for GitHub Actions

resource "google_service_account" "gha" {
  project      = google_project.org_system.project_id
  account_id   = "gha-account"
  display_name = "Github Actions"
  description  = "Github Actions"
}