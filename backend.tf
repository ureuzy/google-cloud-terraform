terraform {
  cloud {
    organization = "ureuzy"
    hostname     = "app.terraform.io"
    workspaces {
      name = "private-gcp"
    }
  }
}