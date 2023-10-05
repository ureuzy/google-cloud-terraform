terraform {
  required_version = "1.6.0"
  required_providers {
    google      = "4.82.0"
    google-beta = "4.82.0"
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }
}