data "google_project" "main" {
  project_id = "ureuzy-ai"
}

module "project-services" {
  source     = "terraform-google-modules/project-factory/google//modules/project_services"
  project_id = data.google_project.main.id
  activate_apis = [
    "aiplatform.googleapis.com",
    "storage-component.googleapis.com",
  ]
}