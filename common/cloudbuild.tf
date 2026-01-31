resource "google_cloudbuildv2_connection" "github_conn" {
  project  = data.google_project.main.project_id
  location = "asia-northeast1"
  name     = "github-conn"

  github_config {
    app_installation_id = "${google_secret_manager_secret.github_cloudbuild_app_id.id}/versions/latest"
    authorizer_credential {
      oauth_token_secret_version = "${google_secret_manager_secret.github_pat.id}/versions/latest"
    }
  }

  depends_on = [
    google_secret_manager_secret_iam_member.cloudbuild_sa_secrets_accessor
  ]
}

resource "google_cloudbuildv2_repository" "cloud_functions" {
  project           = data.google_project.main.project_id
  location          = "asia-northeast1"
  name              = "cloud-functions"
  parent_connection = google_cloudbuildv2_connection.github_conn.name
  remote_uri        = "https://github.com/ureuzy/cloud_functions.git"
}

resource "google_cloudbuild_trigger" "mitene_downloader" {
  project         = data.google_project.main.project_id
  location        = "asia-northeast1"
  name            = "mitene-downloader"
  service_account = google_service_account.cloudbuild.id

  repository_event_config {
    repository = google_cloudbuildv2_repository.cloud_functions.id
    push {
      branch = "^main$"
    }
  }

  included_files = ["mitene-downloader/**"]
  filename       = "mitene-downloader/cloudbuild.yaml"

  substitutions = {
    _REGION        = "asia-northeast1"
    _REPOSITORY    = google_artifact_registry_repository.common.name
    _PIPELINE_NAME = "mitene-downloader"
  }
}
