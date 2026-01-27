resource "google_organization_iam_member" "domain" {
  for_each = toset([
    "roles/resourcemanager.projectCreator",
    "roles/billing.creator"
  ])
  org_id = data.google_organization.ureuzy.org_id
  role   = each.key
  member = "domain:ureuzy.io"
}

resource "google_organization_iam_member" "owner" {
  for_each = toset([
    "roles/owner",
    "roles/viewer"
  ])
  org_id = data.google_organization.ureuzy.org_id
  role   = each.key
  member = "group:gcp-owners@ureuzy.io"
}

resource "google_organization_iam_member" "organization" {
  for_each = toset([
    "roles/cloudsupport.admin",
    "roles/securitycenter.admin",
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.projectCreator",
    "roles/billing.user",
    "roles/iam.organizationRoleAdmin",
    "roles/resourcemanager.organizationAdmin",
    "roles/orgpolicy.policyAdmin"
  ])
  org_id = data.google_organization.ureuzy.org_id
  role   = each.key
  member = "group:gcp-organization-admins@ureuzy.io"
}

resource "google_organization_iam_member" "activity_analyzer" {
  for_each = toset([
    "roles/policyanalyzer.activityAnalysisViewer",
    "roles/resourcemanager.folderViewer"
  ])
  org_id = data.google_organization.ureuzy.org_id
  role   = each.key
  member = "serviceAccount:${google_service_account.activity_analyzer.email}"
}

### Audit Log Aggregation Sink
resource "google_project_iam_member" "log-writer" {
  project = google_project.org_system.id
  role    = "roles/logging.bucketWriter"
  member  = google_logging_organization_sink.audit_log.writer_identity
}

### Audit Log Alert
resource "google_project_iam_member" "publisher" {
  project = google_project.org_system.id
  role    = "roles/pubsub.publisher"
  member  = google_logging_project_sink.auditlogs_alert.writer_identity
}

resource "google_project_iam_member" "invoker" {
  for_each = toset([
    "roles/eventarc.eventReceiver",
    "roles/run.invoker"
  ])
  project = google_project.org_system.id
  role    = each.value
  member  = "serviceAccount:${google_service_account.eventarc.email}"
}

resource "google_project_iam_member" "audit_alert_functions" {
  for_each = toset([
    "roles/secretmanager.secretAccessor"
  ])
  project = google_project.org_system.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.audit_alert_functions.email}"
}

resource "google_project_iam_member" "activity_analyzer" {
  for_each = toset([
    "roles/secretmanager.secretAccessor"
  ])
  project = google_project.org_system.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.activity_analyzer.email}"
}

resource "google_project_iam_member" "mitene_downloader" {
  for_each = toset([
    "roles/secretmanager.secretAccessor",
    "roles/storage.folderAdmin"
  ])
  project = google_project.org_system.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.mitene_downloader.email}"
}

data "google_iam_policy" "service_account_user" {
  binding {
    role = "roles/iam.serviceAccountUser"
    members = [
      "serviceAccount:${google_service_account.gha.email}"
    ]
  }
}

resource "google_service_account_iam_policy" "sa_account_binding" {
  for_each = toset([
    google_service_account.audit_alert_functions.name,
    google_service_account.activity_analyzer.name,
    google_service_account.mitene_downloader.name,
  ])
  service_account_id = each.value
  policy_data        = data.google_iam_policy.service_account_user.policy_data
}

### Workload Identity User for GitHub Actions
resource "google_project_iam_member" "gha" {
  for_each = toset([
    "roles/cloudfunctions.developer",
    "roles/run.developer"
  ])

  project = google_project.org_system.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.gha.email}"
}

data "google_iam_policy" "gha" {
  binding {
    role = "roles/iam.workloadIdentityUser"
    members = [
      "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.gha.name}/attribute.repository/ureuzy/cloud_functions",
    ]
  }
}

resource "google_service_account_iam_policy" "gha" {
  service_account_id = google_service_account.gha.name
  policy_data        = data.google_iam_policy.gha.policy_data
}