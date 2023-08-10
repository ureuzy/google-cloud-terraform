resource "google_project" "ureuzy" {
  name            = "ureuzy"
  project_id      = "ureuzy"
  org_id          = data.google_organization.ureuzy.org_id
  billing_account = data.google_billing_account.account.id
  labels = {
    "firebase" = "enabled"
  }
}

module "project-services" {
  source     = "terraform-google-modules/project-factory/google//modules/project_services"
  version    = "~> 14.2"
  project_id = google_project.ureuzy.project_id
  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
  ]
}

resource "google_project" "ureuzy_tmp" {
  name            = "ureuzy-tmp"
  project_id      = "ureuzy-tmp"
  org_id          = data.google_organization.ureuzy.org_id
  billing_account = data.google_billing_account.account.id
}