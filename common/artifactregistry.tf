resource "google_artifact_registry_repository" "common" {
  location      = "asia-northeast1"
  repository_id = "common"
  format        = "DOCKER"

  cleanup_policies {
    id     = "keep-latest-5"
    action = "KEEP"

    most_recent_versions {
      keep_count = 5
    }
  }
}