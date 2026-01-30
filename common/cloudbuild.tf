resource "google_artifact_registry_repository" "common" {
  project       = data.google_project.main.project_id
  location      = "asia-northeast1"
  repository_id = "common"
  format        = "DOCKER"
}

# 1. GitHub PAT 保存用のシークレット
resource "google_secret_manager_secret" "github_pat" {
  project   = data.google_project.main.project_id
  secret_id = "github-pat"
  replication {
    auto {}
  }
}

# 2. Cloud Build サービスエージェントにシークレットの読み取り権限を付与 (Connection用)
resource "google_secret_manager_secret_iam_member" "cloudbuild_agent_secrets_accessor" {
  project   = data.google_project.main.project_id
  secret_id = google_secret_manager_secret.github_pat.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:service-${data.google_project.main.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
}

# カスタムサービスアカウントにも権限を付与
resource "google_secret_manager_secret_iam_member" "cloudbuild_sa_secrets_accessor" {
  project   = data.google_project.main.project_id
  secret_id = google_secret_manager_secret.github_pat.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloudbuild.email}"
}

# 3. Cloud Build 第2世代の接続 (Connection)
resource "google_cloudbuildv2_connection" "github_conn" {
  project  = data.google_project.main.project_id
  location = "asia-northeast1"
  name     = "github-conn"

  github_config {
    app_installation_id = var.github_app_installation_id

    authorizer_credential {
      oauth_token_secret_version = "${google_secret_manager_secret.github_pat.id}/versions/latest"
    }
  }

  depends_on = [
    google_secret_manager_secret_iam_member.cloudbuild_agent_secrets_accessor,
    google_secret_manager_secret_iam_member.cloudbuild_sa_secrets_accessor
  ]
}

# 4. リポジトリの登録
resource "google_cloudbuildv2_repository" "cloud_functions" {
  project           = data.google_project.main.project_id
  location          = "asia-northeast1"
  name              = "cloud-functions"
  parent_connection = google_cloudbuildv2_connection.github_conn.name
  remote_uri        = "https://github.com/ureuzy/cloud_functions.git"
}

# 5. トリガーの修正 (第2世代を参照)
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
