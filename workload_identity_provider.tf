resource "google_iam_workload_identity_pool" "gha" {
  project                   = google_project.wi_provider_mgmt.project_id
  disabled                  = false
  display_name              = "github-actions"
  workload_identity_pool_id = "github-actions"
}

resource "google_iam_workload_identity_pool_provider" "gha" {
  project                            = google_project.wi_provider_mgmt.project_id
  disabled                           = false
  display_name                       = "github"
  workload_identity_pool_id          = google_iam_workload_identity_pool.gha.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"
  oidc {
    allowed_audiences = []
    issuer_uri        = "https://token.actions.githubusercontent.com"
  }
  attribute_condition = "assertion.repository_owner == 'ureuzy'"
  attribute_mapping = {
    "attribute.actor"      = "assertion.actor"
    "attribute.aud"        = "assertion.aud"
    "attribute.repository" = "assertion.repository"
    "google.subject"       = "assertion.sub"
  }
}

resource "google_iam_workload_identity_pool" "terraform" {
  project                   = google_project.wi_provider_mgmt.project_id
  disabled                  = false
  display_name              = "terraform"
  workload_identity_pool_id = "terraform"
}

resource "google_iam_workload_identity_pool_provider" "terraform" {
  project                            = google_project.wi_provider_mgmt.project_id
  disabled                           = false
  display_name                       = "terraform"
  workload_identity_pool_id          = google_iam_workload_identity_pool.terraform.workload_identity_pool_id
  workload_identity_pool_provider_id = "terraform"
  oidc {
    allowed_audiences = []
    issuer_uri        = "https://app.terraform/io"
  }
  attribute_condition = "assertion.terraform_organization_name == 'ureuzy'"
  attribute_mapping = {
    "attribute.terraform_organization_name" = "assertion.terraform_organization_name"
    "google.subject"                        = "assertion.sub"
  }
}