data "google_organization" "ureuzy" {
  domain = "ureuzy.io"
}

data "google_folder" "sample" {
  folder              = "folders/1079656404947"
  lookup_organization = true
}