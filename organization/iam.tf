### Organization IAM
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
  member = "serviceAccount:activity-analyzer@ureuzy-common.iam.gserviceaccount.com"
}

### Audit Log Aggregation Sink
resource "google_project_iam_member" "log-writer" {
  project = google_project.org_system.id
  role    = "roles/logging.bucketWriter"
  member  = google_logging_organization_sink.audit_log.writer_identity
}

### Audit Log Alert
resource "google_pubsub_topic_iam_member" "audit_alert_publisher" {
  project = "ureuzy-common"
  topic   = "audit-alert"
  role    = "roles/pubsub.publisher"
  member  = google_logging_project_sink.auditlogs_alert.writer_identity
}
