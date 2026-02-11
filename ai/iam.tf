# For AI Reporter SA Permissions

resource "google_project_iam_member" "ai_reporter" {
  for_each = toset([
    "roles/aiplatform.user",
  ])
  project = data.google_project.main.project_id
  role    = each.value
  member  = "serviceAccount:${data.google_service_account.ai_reporter.email}"
}