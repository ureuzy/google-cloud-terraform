#locals {
#  terraformadmin_project_id = "ureuzy"
#  terraform_service_account = "terraform@ureuzy.iam.gserviceaccount.com"
#}
#
#provider "google" {
#  project         = local.terraformadmin_project_id
#  region          = "asia-northeast1"
#  access_token    = data.google_service_account_access_token.default.access_token
#  request_timeout = "60s"
#}
#
#provider "google" {
#  alias = "impersonation"
#  scopes = [
#    "https://www.googleapis.com/auth/cloud-platform",
#    "https://www.googleapis.com/auth/userinfo.email",
#  ]
#}
#
#data "google_service_account_access_token" "default" {
#  provider               = google.impersonation
#  target_service_account = local.terraform_service_account
#  scopes                 = ["userinfo-email", "cloud-platform"]
#  lifetime               = "1200s"
#}

provider "google" {}