resource "google_storage_bucket" "photos" {
  name                        = "ureuzy-family-photos"
  location                    = "ASIA"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  versioning {
    enabled = true
  }
}

resource "google_storage_bucket" "lifecost" {
  name          = "ureuzy-lifecost"
  location      = "ASIA-NORTHEAST1"
  storage_class = "STANDARD"

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  versioning {
    enabled = true
  }
}
