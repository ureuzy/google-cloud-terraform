terraform {
  required_version = "1.14.4"
  required_providers {
    google      = "~> 7.16.0"
    google-beta = "~> 7.16.0"
    sops = {
      source  = "carlpett/sops"
      version = "1.3.0"
    }
  }
}