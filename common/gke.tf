resource "google_container_cluster" "main" {
  name     = "common"
  location = "asia-northeast1-a"

  initial_node_count       = 1
  remove_default_node_pool = true

  release_channel {
    channel = "RAPID"
  }

  deletion_protection = false
}

resource "google_container_node_pool" "default" {
  name     = "default"
  cluster  = google_container_cluster.main.name
  location = google_container_cluster.main.location

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type    = "e2-small"
    spot            = true
    disk_size_gb    = 30
    disk_type       = "pd-standard"
    service_account = google_service_account.service_accounts["gke-common"].email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
