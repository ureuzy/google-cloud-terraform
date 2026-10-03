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
