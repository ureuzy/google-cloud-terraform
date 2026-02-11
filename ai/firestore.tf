resource "google_firestore_database" "main" {
  project     = data.google_project.main.project_id
  name        = "(default)"
  location_id = "asia-northeast1"
  type        = "FIRESTORE_NATIVE"

  # Prevent accidental deletion
  deletion_policy = "DELETE"
}
