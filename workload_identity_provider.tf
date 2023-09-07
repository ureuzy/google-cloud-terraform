resource "google_iam_workload_identity_pool" "pool" {
  project                   = google_project.org_system.project_id
  disabled                  = false
  display_name              = "github-actions"
  workload_identity_pool_id = "github-actions"
}

resource "google_iam_workload_identity_pool_provider" "provider" {
  project                            = google_project.org_system.project_id
  disabled                           = false
  display_name                       = "github"
  workload_identity_pool_id          = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"
  oidc {
    allowed_audiences = []
    issuer_uri        = "https://token.actions.githubusercontent.com"
  }
  attribute_condition = "assertion.repository_owner == 'ureuzy'"
  attribute_mapping   = {
    "attribute.actor"      = "assertion.actor"
    "attribute.aud"        = "assertion.aud"
    "attribute.repository" = "assertion.repository"
    "google.subject"       = "assertion.sub"
  }
}