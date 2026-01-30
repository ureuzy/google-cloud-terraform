# Service Account for mitene-downloader
resource "google_project_iam_member" "mitene_downloader" {
  for_each = toset([
    "roles/run.invoker"
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

# Cloud Build Custom SA Permissions
resource "google_project_iam_member" "cloudbuild" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/artifactregistry.writer",
    "roles/clouddeploy.releaser",
    "roles/iam.serviceAccountUser", # To deploy as the Run SA
    "roles/storage.admin"           # For build artifacts/logs
  ])

  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.cloudbuild.email}"
}




# Secret Manager Access (Limited to specific secrets)
resource "google_secret_manager_secret_iam_member" "mitene_downloader_secrets" {
  for_each = toset([
    google_secret_manager_secret.slack_webhook.secret_id,
    google_secret_manager_secret.mitene_url.secret_id,
  ])

  project   = data.google_project.main.project_id
  secret_id = each.value
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.mitene_downloader.email}"
}