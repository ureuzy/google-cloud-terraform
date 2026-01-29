resource "google_pubsub_topic" "audit_alert" {
  name         = "auditlogs_alert"
  project      = google_project.org_system.project_id
  kms_key_name = google_kms_crypto_key.pubsub_key.id
  depends_on   = [google_kms_crypto_key_iam_member.crypto_key]
}

resource "google_pubsub_topic" "activity_analyzer" {
  name         = "activity-analyzer"
  project      = google_project.org_system.project_id
  kms_key_name = google_kms_crypto_key.pubsub_key.id
  depends_on   = [google_kms_crypto_key_iam_member.crypto_key]
}

resource "google_pubsub_topic" "mitene_downloader" {
  name         = "mitene-downloader"
  project      = google_project.org_system.project_id
  kms_key_name = google_kms_crypto_key.pubsub_key.id
  depends_on   = [google_kms_crypto_key_iam_member.crypto_key]
}