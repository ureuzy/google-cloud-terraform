# For CloudBuild SA Permissions
resource "google_project_iam_member" "cloudbuild" {
  for_each = toset([
    "roles/cloudbuild.builds.builder",
    "roles/iam.serviceAccountUser",
    "roles/logging.logWriter",
    "roles/clouddeploy.operator",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.cloudbuild.email}"
}

# For Cloud Deploy execution using custom Service Account
resource "google_project_iam_member" "clouddeploy" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/clouddeploy.jobRunner",
    "roles/run.developer",
    "roles/iam.serviceAccountUser",
    "roles/artifactregistry.reader",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.clouddeploy.email}"

}

# For mitene downloader SA Permissions
resource "google_project_iam_member" "mitene_downloader" {
  for_each = toset([
    "roles/run.invoker",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.mitene_downloader.email}"
}

resource "google_storage_bucket_iam_member" "mitene_downloader_photos" {
  bucket = google_storage_bucket.photos.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.mitene_downloader.email}"
}

resource "google_secret_manager_secret_iam_member" "mitene_downloader_secrets" {
  for_each = toset([
    google_secret_manager_secret.slack_webhook.secret_id,
    google_secret_manager_secret.mitene_url.secret_id,
  ])
  secret_id = each.value
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.mitene_downloader.email}"
}

# For Activity Analyzer SA Permissions
resource "google_project_iam_member" "activity_analyzer" {
  for_each = toset([
    "roles/run.invoker",
    "roles/secretmanager.secretAccessor",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.activity_analyzer.email}"
}

# For Audit Alert SA Permissions
resource "google_project_iam_member" "audit_alert" {
  for_each = toset([
    "roles/run.invoker",
    "roles/secretmanager.secretAccessor",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.audit_alert.email}"
}

# Allow Pub/Sub to create tokens for audit-alert SA
resource "google_service_account_iam_member" "pubsub_token_creator" {
  service_account_id = google_service_account.audit_alert.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:service-${data.google_project.main.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

