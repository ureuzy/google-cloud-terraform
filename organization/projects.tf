data "google_organization" "ureuzy" {
  domain = "ureuzy.io"
}

resource "google_project" "org_system" {
  name            = "ureuzy-org-system"
  project_id      = "ureuzy-org-system"
  org_id          = data.google_organization.ureuzy.org_id
  billing_account = data.google_billing_account.account.id
}

module "project-services" {
  source     = "terraform-google-modules/project-factory/google//modules/project_services"
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
    "policyanalyzer.googleapis.com",
    "compute.googleapis.com",
    "bigquery.googleapis.com"
  ]
}

resource "google_project" "ureuzy" {
  name            = "ureuzy"
  project_id      = "ureuzy"
  org_id          = data.google_organization.ureuzy.org_id
  billing_account = data.google_billing_account.account.id
  labels = {
    "firebase" = "enabled"
  }
}

resource "google_project" "ai" {
  name            = "ureuzy-ai"
  project_id      = "ureuzy-ai"
  org_id          = data.google_organization.ureuzy.org_id
  billing_account = data.google_billing_account.account.id
}

resource "google_project" "common" {
  name            = "ureuzy-common"
  project_id      = "ureuzy-common"
  org_id          = data.google_organization.ureuzy.org_id
  billing_account = data.google_billing_account.account.id
}
