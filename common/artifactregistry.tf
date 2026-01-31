resource "google_artifact_registry_repository" "common" {
  location      = "asia-northeast1"
  repository_id = "common"
  format        = "DOCKER"
}