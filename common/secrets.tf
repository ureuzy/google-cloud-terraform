resource "google_secret_manager_secret" "slack_webhook" {
  project   = data.google_project.main.project_id
  secret_id = "slack-webhook"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "mitene_url" {
  project   = data.google_project.main.project_id
  secret_id = "mitene-url"
  replication {
    auto {}
  }
}

# For CloudBuild
resource "google_secret_manager_secret" "github_pat" {
  project   = data.google_project.main.project_id
  secret_id = "github-pat"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "github_cloudbuild_app_id" {
  project   = data.google_project.main.project_id
  secret_id = "github-cloudbuild-app-id"
  replication {
    auto {}
  }
}