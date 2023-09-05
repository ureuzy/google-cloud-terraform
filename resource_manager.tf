data "google_organization" "ureuzy" {
  domain = "ureuzy.io"
}

resource "google_folder" "projects" {
  display_name = "projects"
  parent       = data.google_organization.ureuzy.id
}

resource "google_project" "ureuzy" {
  name            = "ureuzy"
  project_id      = "ureuzy"
  folder_id       = google_folder.projects.name
  billing_account = data.google_billing_account.account.id
  labels          = {
    "firebase" = "enabled"
  }
}

resource "google_project" "ureuzy_tmp" {
  name            = "ureuzy-tmp"
  project_id      = "ureuzy-tmp"
  folder_id       = google_folder.projects.name
  billing_account = data.google_billing_account.account.id
}

module "project-services" {
  source        = "terraform-google-modules/project-factory/google//modules/project_services"
  version       = "~> 14.2"
  project_id    = google_project.ureuzy.project_id
  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "dataflow.googleapis.com"
  ]
}

resource "google_project" "org_system" {
  name            = "ureuzy-org-system"
  project_id      = "ureuzy-org-system"
  org_id          = data.google_organization.ureuzy.org_id
  billing_account = data.google_billing_account.account.id
}