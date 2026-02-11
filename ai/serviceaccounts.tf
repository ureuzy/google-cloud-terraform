data "google_service_account" "ai_reporter" {
  project = "ureuzy-common"
  account_id = "ai-reporter"
}

data "google_service_account" "ai_sensei" {
  project = "ureuzy-common"
  account_id = "ai-sensei"
}