data "google_project" "main" {
  project_id = "ureuzy-common"
}

module "project-services" {
  source     = "terraform-google-modules/project-factory/google//modules/project_services"
  project_id = data.google_project.main.id
  activate_apis = [
    "cloudbuild.googleapis.com",
    "run.googleapis.com",
    "clouddeploy.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com",
    "cloudscheduler.googleapis.com",
    "storage.googleapis.com",
    "iam.googleapis.com",
    "monitoring.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "policyanalyzer.googleapis.com"
  ]
}