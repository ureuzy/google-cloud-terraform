data "google_project" "main" {
  project_id = "ureuzy-common"
}

module "project-services" {
  source     = "terraform-google-modules/project-factory/google//modules/project_services"
  project_id = data.google_project.main.id
  activate_apis = [
    "cloudbuild.googleapis.com",
  ]
}