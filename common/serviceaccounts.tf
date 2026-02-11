resource "google_service_account" "mitene_downloader" {
  account_id   = "mitene-downloader"
  display_name = "mitene-downloader"
  description  = "Service Account for mitene downloader Cloud Run Job"
}

resource "google_service_account" "billing_monitor" {
  account_id   = "billing-monitor"
  display_name = "billing-monitor"
  description  = "Service Account for the billing-monitor Cloud Run Job"
}

resource "google_service_account" "activity_analyzer" {
  account_id   = "activity-analyzer"
  display_name = "activity-analyzer"
  description  = "Analyze unused service account"
}

resource "google_service_account" "audit_alert" {
  account_id   = "audit-alert"
  display_name = "audit-alert"
  description  = "Service Account for Audit alert"
}

resource "google_service_account" "ai_reporter" {
  account_id   = "ai-reporter"
  display_name = "ai-reporter"
  description  = "Service Account for the ai-reporter Cloud Run Job"
}

resource "google_service_account" "common_api" {
  account_id   = "common-api"
  display_name = "common-api"
  description  = "Service Account for the common-api Cloud Run Service"
}

resource "google_service_account" "cloudbuild" {
  account_id   = "cloudbuild"
  display_name = "Cloud Build Service Account"
  description  = "Custom Service Account for Cloud Build triggers"
}

resource "google_service_account" "clouddeploy" {
  account_id   = "clouddeploy"
  display_name = "Cloud Deploy Execution Service Account"
  description  = "Custom Service Account for Cloud Deploy operations"
}
