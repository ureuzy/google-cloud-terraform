terraform {
  required_version = "1.4.4"
  required_providers {
    google      = "4.72.1"
    google-beta = "4.60.2"
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }
}