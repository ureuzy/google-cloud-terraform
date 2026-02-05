resource "google_bigquery_dataset" "billing_export" {
  dataset_id                  = "gcp_billing_export"
  friendly_name               = "GCP Billing Export"
  description                 = "Dataset for GCP billing export from billing account"
  location                    = "asia-northeast1"
  project                     = google_project.org_system.project_id
  default_table_expiration_ms = null # 課金データは長期保存するため無期限に設定

  labels = {
    env = "production"
  }
}
