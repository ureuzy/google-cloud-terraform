terraform {
  cloud {
    organization = "ureuzy"
    hostname     = "app.terraform.io"
    workspaces {
      name = "organization_gcp"
    }
  }
}