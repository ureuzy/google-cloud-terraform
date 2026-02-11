# For AI Reporter SA Permissions

resource "google_project_iam_member" "ai_reporter" {
  for_each = toset([
    "roles/aiplatform.user",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${data.google_service_account.ai_reporter.email}"
}

# For AI Sensei SA Permissions
resource "google_project_iam_member" "ai_sensei" {
  for_each = toset([
    "roles/aiplatform.user",
    "roles/datastore.user",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${data.google_service_account.ai_reporter.email}"
}