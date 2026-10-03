# コンソール (ureuzy.io) の地図表示に使う Maps JavaScript API のキー
# ブラウザに埋め込むキーなので、使える API と呼び出し元のサイトを絞る
# ローカル開発は flutter run -d chrome --web-port 8000 で起動する (ポートにワイルドカードは使えない)
resource "google_apikeys_key" "maps_browser" {
  name         = "maps-browser"
  display_name = "Maps JavaScript API (ureuzy.io console)"
  project      = data.google_project.main.project_id

  restrictions {
    api_targets {
      service = "maps-backend.googleapis.com"
    }
    browser_key_restrictions {
      allowed_referrers = [
        "https://ureuzy.io/*",
        "http://localhost:8000/*",
      ]
    }
  }

  depends_on = [module.project-services]
}

output "maps_browser_key" {
  value     = google_apikeys_key.maps_browser.key_string
  sensitive = true
}

# 地図の表示回数を 1 日 300 回までにする。30 日使い切っても月の無料枠 (10,000 回) に収まる
# metric と limit の名前は Service Usage API の consumerQuotaMetrics で確認したもの
resource "google_service_usage_consumer_quota_override" "maps_daily_loads" {
  provider       = google-beta
  project        = data.google_project.main.project_id
  service        = "maps-backend.googleapis.com"
  metric         = urlencode("maps-backend.googleapis.com/billable_default")
  limit          = urlencode("/d/project")
  override_value = "300"
  # 無制限からの引き下げは 10% を超える減少になるので force が必要
  force = true

  depends_on = [module.project-services]
}
