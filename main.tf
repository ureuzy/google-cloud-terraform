data "google_organization" "ureuzy" {
  domain = "ureuzy.io"
}

data "google_billing_account" "account" {
  billing_account = data.sops_file.sops.data["billing_account"]
}
