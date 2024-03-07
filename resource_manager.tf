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
  labels = {
    "firebase" = "enabled"
  }
}

resource "google_project" "wi_provider_mgmt" {
  name            = "ureuzy-wi-provider-mgmt"
  project_id      = "ureuzy-wi-provider-mgmt"
  org_id          = data.google_organization.ureuzy.org_id
  billing_account = data.google_billing_account.account.id
}

resource "google_project" "org_system" {
  name            = "ureuzy-org-system"
  project_id      = "ureuzy-org-system"
  org_id          = data.google_organization.ureuzy.org_id
  billing_account = data.google_billing_account.account.id
}

resource "google_project" "test" {
  name            = "ureuzy-compute-test"
  project_id      = "ureuzy-compute-test"
  org_id          = data.google_organization.ureuzy.org_id
  billing_account = data.google_billing_account.account.id
}

resource "google_project" "gke_test" {
  name            = "ureuzy-gke-test"
  project_id      = "ureuzy-gke-test"
  org_id          = data.google_organization.ureuzy.org_id
  billing_account = data.google_billing_account.account.id
}

module "project-services" {
  source     = "terraform-google-modules/project-factory/google//modules/project_services"
  version    = "~> 14.2"
  project_id = google_project.org_system.project_id
  activate_apis = [
    "iam.googleapis.com",
    "cloudbilling.googleapis.com",
    "billingbudgets.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "run.googleapis.com",
    "pubsub.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com",
    "eventarc.googleapis.com",
    "cloudkms.googleapis.com",
    "recommender.googleapis.com",
    "policyanalyzer.googleapis.com",
    "compute.googleapis.com"
  ]
}