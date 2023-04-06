resource "google_project" "ureuzy" {
  name            = "ureuzy"
  project_id      = "ureuzy"
  org_id          = data.google_organization.ureuzy.org_id
  billing_account = data.google_billing_account.account.id
  labels = {
    "firebase" = "enabled"
  }
}

#resource "google_project" "onboarding" {
#  name            = "Onboarding Host Project"
#  project_id      = "onboarding-host-230b35baceed41"
#  org_id          = data.google_organization.ureuzy.org_id
#  billing_account = data.google_billing_account.account.id
#  labels = {
#    "gcp-onboarding-can-delete"          = "true"
#    "gcp-onboarding-component"           = "oc-host-project"
#    "gcp-onboarding-host-project-org-id" = "948429943190"
#  }
#}

#resource "google_project" "my_first_project" {
#  name            = "My First Project"
#  project_id      = "ornate-destiny-380011"
#  org_id          = data.google_organization.ureuzy.org_id
#  billing_account = data.google_billing_account.account.id
#}