locals {
  project = "ureuzy"
}

resource "google_project_service" "kms" {
  service            = "cloudkms.googleapis.com"
  project            = local.project
  disable_on_destroy = false
}

resource "google_kms_key_ring" "sops" {
  name     = "sops"
  location = "asia1"
  project  = local.project

  depends_on = [google_project_service.kms]
}

resource "google_kms_crypto_key" "sops_terraform" {
  name     = "terraform"
  key_ring = google_kms_key_ring.sops.id
  purpose  = "ENCRYPT_DECRYPT"

  lifecycle {
    prevent_destroy = true
  }
}