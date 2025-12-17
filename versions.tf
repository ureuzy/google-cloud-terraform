terraform {
  required_version = "1.14.3"
  required_providers {
    google      = "~> 7.4.0"
    google-beta = "~> 7.4.0"
    sops = {
      source  = "carlpett/sops"
      version = "1.2.1"
    }
  }
}