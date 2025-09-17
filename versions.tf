terraform {
  required_version = "1.13.3"
  required_providers {
    google      = "4.82.0"
    google-beta = "4.82.0"
    sops = {
      source  = "carlpett/sops"
      version = "1.0.0"
    }
  }
}