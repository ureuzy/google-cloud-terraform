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

resource "google_iam_workload_identity_pool_provider" "organization" {
  project                            = google_project.wi_provider_mgmt.project_id
  disabled                           = false
  display_name                       = "organization"
  workload_identity_pool_id          = google_iam_workload_identity_pool.terraform.workload_identity_pool_id
  workload_identity_pool_provider_id = "organization"
  oidc {
    allowed_audiences = []
    issuer_uri        = "https://app.terraform.io"
  }
  attribute_condition = "assertion.terraform_workspace_name == 'organization_gcp'"
  attribute_mapping = {
    "attribute.terraform_workspace_name" = "assertion.terraform_workspace_name"
    "google.subject"                     = "assertion.sub"
  }
}

resource "google_iam_workload_identity_pool_provider" "konotalos" {
  project                            = google_project.wi_provider_mgmt.project_id
  disabled                           = false
  display_name                       = "konotalos"
  workload_identity_pool_id          = google_iam_workload_identity_pool.terraform.workload_identity_pool_id
  workload_identity_pool_provider_id = "konotalos"
  oidc {
    allowed_audiences = []
    issuer_uri        = "https://app.terraform.io"
  }
  attribute_condition = "assertion.terraform_workspace_name == 'konotalos'"
  attribute_mapping = {
    "attribute.terraform_workspace_name" = "assertion.terraform_workspace_name"
    "google.subject"                     = "assertion.sub"
  }
}

resource "google_iam_workload_identity_pool_provider" "gke_test" {
  project                            = google_project.wi_provider_mgmt.project_id
  disabled                           = false
  display_name                       = "gke-test"
  workload_identity_pool_id          = google_iam_workload_identity_pool.terraform.workload_identity_pool_id
  workload_identity_pool_provider_id = "gke-test"
  oidc {
    allowed_audiences = []
    issuer_uri        = "https://app.terraform.io"
  }
  attribute_condition = "assertion.terraform_workspace_name == 'ureuzy-gke-test'"
  attribute_mapping = {
    "attribute.terraform_workspace_name" = "assertion.terraform_workspace_name"
    "google.subject"                     = "assertion.sub"
  }
}
