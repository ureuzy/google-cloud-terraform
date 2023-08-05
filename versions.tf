terraform {
  required_version = "1.5.4"
  required_providers {
    google      = "4.76.0"
    google-beta = "4.76.0"
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }
}