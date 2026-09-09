resource "google_firestore_database" "default" {
  project     = data.google_project.main.project_id
  name        = "(default)"
  location_id = "asia-northeast1"
  type        = "FIRESTORE_NATIVE"

  delete_protection_state = "DELETE_PROTECTION_ENABLED"

  depends_on = [module.project-services]
}

# 既存の (default) がある場合はコメントを外す
# import {
#   id = "projects/ureuzy-common/databases/(default)"
#   to = google_firestore_database.default
# }
