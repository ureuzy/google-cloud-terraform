resource "google_storage_bucket" "photos" {
  name                     = "ureuzy-photos"
  location                 = "ASIA"
  project                  = google_project.org_system.project_id
  public_access_prevention = "enforced"
  force_destroy            = false
}

resource "google_storage_bucket" "test" {
  name                     = "ureuzy-test"
  location                 = "asia-northeast1"
  project                  = google_project.org_system.project_id
  public_access_prevention = "enforced"
  force_destroy            = false
}