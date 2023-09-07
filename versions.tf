terraform {
  required_version = "1.5.7"
  required_providers {
    google      = "4.80.0"
    google-beta = "4.80.0"
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }
}