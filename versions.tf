terraform {
  required_version = "1.5.5"
  required_providers {
    google      = "4.78.0"
    google-beta = "4.78.0"
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }
}