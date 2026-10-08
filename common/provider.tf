provider "google" {
  project               = "ureuzy-common"
  region                = "asia-northeast-1"
  user_project_override = true
  # API の呼び出しを ureuzy-common に付ける。付けないと、認証の quota project (ureuzy-org-system) に付けられ、
  # そこで有効になっていない API (API Keys API など) が断られる
  billing_project = "ureuzy-common"
}
# google にない (beta の) リソース用。設定は google と同じ
provider "google-beta" {
  project               = "ureuzy-common"
  region                = "asia-northeast-1"
  user_project_override = true
  billing_project       = "ureuzy-common"
}
