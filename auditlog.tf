resource "google_logging_project_bucket_config" "audit_log" {
  project        = google_project.ureuzy.id
  location       = "global"
  retention_days = 30
  bucket_id      = "all-audit-logs-bucket"
}

resource "google_logging_organization_sink" "audit_log" {
  name        = "all-audit-logs-sink"
  description = "All audit logs from my org log sink"
  org_id      = data.google_organization.ureuzy.org_id
  destination = "logging.googleapis.com/${google_logging_project_bucket_config.audit_log.id}"
}

resource "google_project_iam_member" "log-writer" {
  project = google_project.ureuzy.id
  role    = "roles/logging.bucketWriter"
  member  = google_logging_organization_sink.audit_log.writer_identity
}

resource "google_logging_project_exclusion" "my-exclusion" {
  name = "my-instance-debug-exclusion"
  description = "Exclude GCE instance debug logs"
  filter = "resource.type = gce_instance AND severity <= DEBUG"
}