resource "google_logging_project_bucket_config" "audit_log" {
  project        = google_project.org_system.project_id
  location       = "global"
  retention_days = 30
  bucket_id      = "all-audit-logs-bucket"
}

resource "google_logging_organization_sink" "audit_log" {
  org_id           = data.google_organization.ureuzy.org_id
  name             = "all-audit-logs-sink"
  description      = "All audit logs from my org log sink"
  destination      = "logging.googleapis.com/projects/${google_project.org_system.project_id}"
  include_children = true
  filter           = "logName:cloudaudit.googleapis.com"
}

resource "google_project_iam_member" "log-writer" {
  project = google_project.org_system.id
  role    = "roles/logging.bucketWriter"
  member  = google_logging_organization_sink.audit_log.writer_identity
}

resource "google_logging_project_exclusion" "ureuzy" {
  project     = google_project.ureuzy.project_id
  name        = "auditlogs"
  description = "Exclude audit logs"
  filter      = "logName:cloudaudit.googleapis.com"
}

resource "google_logging_project_exclusion" "ureuzy_tmp" {
  project     = google_project.ureuzy_tmp.project_id
  name        = "auditlogs"
  description = "Exclude audit logs"
  filter      = "logName:cloudaudit.googleapis.com"
}

resource "google_logging_project_exclusion" "org_system" {
  project     = google_project.org_system.project_id
  name        = "auditlogs"
  description = "Exclude audit logs"
  filter      = "logName:cloudaudit.googleapis.com"
}

# AuditLog Alert
resource "google_logging_project_sink" "auditlogs_alert" {
  project = google_project.org_system.project_id
  name                   = "auditlogs_alert"
  destination            = "pubsub.googleapis.com/${google_pubsub_topic.main.id}"
  filter                 = "protoPayload.methodName=\"SetIamPolicy\" OR protoPayload.methodName=\"google.cloud.bigquery.v2.JobService.InsertJob\""
  unique_writer_identity = true
}

resource "google_project_iam_member" "publisher" {
  project = google_project.org_system.id
  role    = "roles/pubsub.publisher"
  member  = google_logging_project_sink.auditlogs_alert.writer_identity
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

resource "google_pubsub_topic" "main" {
  name         = "auditlogs_alert"
  project      = google_project.org_system.project_id
  kms_key_name = google_kms_crypto_key.pubsub_key.id
  depends_on   = [google_kms_crypto_key_iam_member.crypto_key]
}

resource "google_service_account" "eventarc" {
  project      = google_project.org_system.project_id
  account_id   = "eventarc"
  display_name = "Eventarc Trigger"
}

resource "google_project_iam_member" "sample" {
  project = google_project.org_system.id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.eventarc.email}"
}

resource "google_eventarc_trigger" "main" {
  project  = google_project.org_system.project_id
  name     = "test"
  location = "asia-northeast1"
  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }
  destination {
    cloud_run_service {
      path    = "/"
      region  = "asia-northeast1"
      service = "test"
    }
  }
  transport {
    pubsub {
      topic = google_pubsub_topic.main.id
    }
  }
  timeouts {}
  service_account = google_service_account.eventarc.email
}
