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
# common-api のダッシュボード: リクエスト・応答時間・起動の遅さ・CPU とメモリ・写真のバケット・エラーのログ。
# 載せるのは Cloud Run と Cloud Storage が最初から記録している数字だけ (料金はかからない)。API ごとの時間は Cloud Trace で見る
resource "google_monitoring_dashboard" "common_api" {
  dashboard_json = file("${path.module}/dashboards/common-api.json")
}
