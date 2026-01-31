resource "google_artifact_registry_repository" "common" {
  project       = data.google_project.main.project_id
  location      = "asia-northeast1"
  repository_id = "common"
  format        = "DOCKER"
}