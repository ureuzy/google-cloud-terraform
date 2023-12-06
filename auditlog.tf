### Audit Log Aggregation Sink
#resource "google_logging_project_bucket_config" "audit_log" {
#  project        = google_project.org_system.project_id
#  location       = "global"
#  retention_days = 30
#  bucket_id      = "all-audit-logs-bucket"
#}

resource "google_organization_iam_audit_config" "data_access" {
  for_each = toset([
    "iam.googleapis.com",
    "sts.googleapis.com"
  ])
  org_id  = data.google_organization.ureuzy.org_id
  service = each.value

  dynamic "audit_log_config" {
    for_each = toset([
      "ADMIN_READ",
      "DATA_READ",
      "DATA_WRITE"
    ])
    content {
      log_type = audit_log_config.value
    }
  }
}

resource "google_logging_organization_sink" "audit_log" {
  org_id           = data.google_organization.ureuzy.org_id
  name             = "all-audit-logs-sink"
  description      = "All audit logs from my org log sink"
  destination      = "logging.googleapis.com/projects/${google_project.org_system.project_id}"
  include_children = true
  filter           = "logName:cloudaudit.googleapis.com"
}

resource "google_logging_project_exclusion" "audit_log" {
  for_each = toset([
    google_project.ureuzy.project_id,
    google_project.exam.project_id
  ])
  project     = each.value
  name        = "auditlogs"
  description = "Exclude audit logs"
  filter      = "logName:cloudaudit.googleapis.com"
}

// require before import
resource "google_logging_project_sink" "default" {
  name                   = "_Default"
  destination            = "logging.googleapis.com/projects/ureuzy-org-system/locations/global/buckets/_Default"
  description            = ""
  filter                 = ""
  unique_writer_identity = true
}

### AuditLog Alert
resource "google_logging_project_sink" "auditlogs_alert" {
  project                = google_project.org_system.project_id
  name                   = "auditlogs_alert"
  destination            = "pubsub.googleapis.com/${google_pubsub_topic.audit_alert.id}"
  filter                 = "protoPayload.methodName=\"SetIamPolicy\" OR protoPayload.methodName=\"google.cloud.bigquery.v2.JobService.InsertJob\""
  unique_writer_identity = true
}

resource "google_kms_key_ring" "pubsub_keyring" {
  project  = google_project.org_system.project_id
  name     = "pubsub_keyring"
  location = "global"
}

resource "google_kms_crypto_key" "pubsub_key" {
  name     = "pubsub_key"
  key_ring = google_kms_key_ring.pubsub_keyring.id
}

resource "google_kms_crypto_key_iam_member" "crypto_key" {
  crypto_key_id = google_kms_crypto_key.pubsub_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${google_project.org_system.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_pubsub_topic" "audit_alert" {
  name         = "auditlogs_alert"
  project      = google_project.org_system.project_id
  kms_key_name = google_kms_crypto_key.pubsub_key.id
  depends_on   = [google_kms_crypto_key_iam_member.crypto_key]
}

resource "google_eventarc_trigger" "audit_alert" {
  project  = google_project.org_system.project_id
  name     = "audit-alert"
  location = "asia-northeast1"
  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }
  destination {
    cloud_run_service {
      path    = "/"
      region  = "asia-northeast1"
      service = "audit-alert"
    }
  }
  transport {
    pubsub {
      topic = google_pubsub_topic.audit_alert.id
    }
  }
  timeouts {}
  service_account = google_service_account.eventarc.email
}