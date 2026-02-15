resource "google_container_cluster" "main" {
  name     = "common"
  location = "asia-northeast1"

  enable_autopilot = true

  cluster_autoscaling {
    auto_provisioning_defaults {
      service_account = google_service_account.gke_common.email
    }
  }

  deletion_protection = false
}
