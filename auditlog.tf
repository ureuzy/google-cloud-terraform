resource "google_logging_project_bucket_config" "audit_log" {
  project        = google_project.ureuzy.project_id
  location       = "global"
  retention_days = 30
  bucket_id      = "all-audit-logs-bucket"
}

resource "google_logging_organization_sink" "audit_log" {
  name             = "all-audit-logs-sink"
  description      = "All audit logs from my org log sink"
  org_id           = data.google_organization.ureuzy.org_id
  destination      = "logging.googleapis.com/${google_logging_project_bucket_config.audit_log.id}"
  include_children = true
  filter           = "logName:cloudaudit.googleapis.com"
}

resource "google_project_iam_member" "log-writer" {
  project = google_project.ureuzy.id
  role    = "roles/logging.bucketWriter"
  member  = google_logging_organization_sink.audit_log.writer_identity
}

resource "google_logging_project_exclusion" "ureuzy" {
  name        = "auditlogs"
  project     = google_project.ureuzy.project_id
  description = "Exclude audit logs"
  filter      = "logName:cloudaudit.googleapis.com"
}

resource "google_logging_project_exclusion" "ureuzy-tmp" {
  name        = "auditlogs"
  project     = google_project.ureuzy_tmp.project_id
  description = "Exclude audit logs"
  filter      = "logName:cloudaudit.googleapis.com"
}

# AuditLog Alert
#resource "google_logging_project_sink" "auditlogs_alert" {
#  name                   = "auditlogs_alert"
#  destination            = "pubsub.googleapis.com/${google_pubsub_topic.main.id}"
#  filter                 = "protoPayload.methodName: SetIamPolicy"
#  unique_writer_identity = true
#}
#
#resource "google_project_iam_member" "publisher" {
#  project = google_project.ureuzy.id
#  role    = "roles/pubsub.publisher"
#  member  = google_logging_project_sink.auditlogs_alert.writer_identity
#}
#
#resource "google_pubsub_topic" "main" {
#  name = "auditlogs_alert"
#  timeouts {}
#}
#
#resource "google_eventarc_trigger" "main" {
#  provider = google-beta
#  name     = "test"
#  location = "asia-northeast1"
#  project  = google_project.ureuzy.project_id
#  matching_criteria {
#    attribute = "type"
#    value     = "google.cloud.pubsub.topic.v1.messagePublished"
#  }
#  destination {
#    cloud_run_service {
#      path    = "/"
#      region  = "asia-northeast1"
#      service = "test"
#    }
#  }
#  transport {
#    pubsub {
#      topic = google_pubsub_topic.main.id
#    }
#  }
#  timeouts {}
#  service_account = "375832898018-compute@developer.gserviceaccount.com"
#}
