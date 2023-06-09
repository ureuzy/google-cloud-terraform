resource "google_project" "ureuzy" {
  name            = "ureuzy"
  project_id      = "ureuzy"
  org_id          = data.google_organization.ureuzy.org_id
  billing_account = data.google_billing_account.account.id
  labels = {
    "firebase" = "enabled"
  }
}

resource "google_project" "ureuzy_tmp" {
  name            = "ureuzy-tmp"
  project_id      = "ureuzy-tmp"
  org_id          = data.google_organization.ureuzy.org_id
  billing_account = data.google_billing_account.account.id
}