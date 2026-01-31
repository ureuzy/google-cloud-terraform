resource "google_monitoring_alert_policy" "run_job" {
  display_name = "Cloud Run Job"
  combiner     = "OR"
  conditions {
    display_name = "cloud run job condition"
    condition_matched_log {
      filter = "resource.type=\"cloud_run_job\" AND severity=\"ERROR\""
    }
  }
  alert_strategy {
    notification_rate_limit {
      period = "86400s"
    }
    auto_close = "86400s"
    notification_prompts = [
      "OPENED"
    ]
  }
  enabled  = true
  severity = "ERROR"
}