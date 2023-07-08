terraform {
  required_version = "~> 1.5.0"
  required_providers {
    google      = "4.72.1"
    google-beta = "4.72.1"
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }
}