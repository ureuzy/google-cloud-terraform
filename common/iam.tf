# Service Account for mitene-downloader
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

# Activity Analyzer
resource "google_project_iam_member" "activity_analyzer" {
  for_each = toset([
    "roles/run.invoker",
    "roles/secretmanager.secretAccessor",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.activity_analyzer.email}"
}

# Audit Alert
resource "google_project_iam_member" "audit_alert" {
  for_each = toset([
    "roles/run.invoker",
    "roles/secretmanager.secretAccessor",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.audit_alert.email}"
}

# Eventarc
resource "google_project_iam_member" "eventarc" {
  for_each = toset([
    "roles/eventarc.eventReceiver",
    "roles/run.developer",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.eventarc.email}"
}
