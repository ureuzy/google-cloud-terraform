locals {
  project = "ureuzy-org-system"
}

resource "google_kms_key_ring" "sops" {
  name     = "sops"
  location = "asia1"
  project  = local.project
}

resource "google_kms_crypto_key" "sops_terraform" {
  name     = "terraform"
  key_ring = google_kms_key_ring.sops.id
  purpose  = "ENCRYPT_DECRYPT"
  lifecycle {
    prevent_destroy = true
  }
}