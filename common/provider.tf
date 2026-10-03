provider "google" {
  project               = "ureuzy-common"
  region                = "asia-northeast-1"
  user_project_override = true
}
# google にない (beta の) リソース用。設定は google と同じ
provider "google-beta" {
  project               = "ureuzy-common"
  region                = "asia-northeast-1"
  user_project_override = true
}
