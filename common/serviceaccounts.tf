locals {
  service_accounts = {
    "mitene-downloader" = "Service Account for mitene downloader Cloud Run Job"
    "billing-monitor"   = "Service Account for the billing-monitor Cloud Run Job"
    "activity-analyzer" = "Analyze unused service account"
    "audit-alert"       = "Service Account for Audit alert"
    "ai-reporter"       = "Service Account for the ai-reporter Cloud Run Job"
    "ai-sensei"         = "Service Account for the ai-sensei services (daily-poster and event-handler)"
    "common-api"        = "Service Account for the common-api Cloud Run Service"
    "gke-common"        = "Service Account for GKE Autopilot cluster"
    "cloudbuild"        = "Custom Service Account for Cloud Build triggers"
    "clouddeploy"       = "Custom Service Account for Cloud Deploy operations"
  }
}

resource "google_service_account" "service_accounts" {
  for_each     = local.service_accounts
  account_id   = each.key
  display_name = each.key
  description  = each.value
}
