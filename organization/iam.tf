### Organization IAM
resource "google_organization_iam_member" "domain" {
  for_each = toset([
    "roles/resourcemanager.projectCreator",
    "roles/billing.creator"
  ])
  org_id = data.google_organization.ureuzy.org_id
  role   = each.key
  member = "domain:ureuzy.io"
}

resource "google_organization_iam_member" "owner" {
  for_each = toset([
    "roles/owner",
    "roles/viewer"
  ])
  org_id = data.google_organization.ureuzy.org_id
  role   = each.key
  member = "group:gcp-owners@ureuzy.io"
}

resource "google_organization_iam_member" "organization" {
  for_each = toset([
    "roles/cloudsupport.admin",
    "roles/securitycenter.admin",
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.projectCreator",
    "roles/billing.user",
    "roles/iam.organizationRoleAdmin",
    "roles/resourcemanager.organizationAdmin",
    "roles/orgpolicy.policyAdmin"
  ])
  org_id = data.google_organization.ureuzy.org_id
  role   = each.key
  member = "group:gcp-organization-admins@ureuzy.io"
}

resource "google_organization_iam_member" "activity_analyzer" {
  for_each = toset([
    "roles/policyanalyzer.activityAnalysisViewer",
    "roles/resourcemanager.folderViewer"
  ])
  org_id = data.google_organization.ureuzy.org_id
  role   = each.key
  member = "serviceAccount:activity-analyzer@ureuzy-common.iam.gserviceaccount.com"
}

### Audit Log Aggregation Sink
resource "google_project_iam_member" "log-writer" {
  project = google_project.org_system.id
  role    = "roles/logging.bucketWriter"
  member  = google_logging_organization_sink.audit_log.writer_identity
}

### Audit Log Alert
resource "google_pubsub_topic_iam_member" "audit_alert_publisher" {
  project = "ureuzy-common"
  topic   = "audit-alert"
  role    = "roles/pubsub.publisher"
  member  = google_logging_project_sink.auditlogs_alert.writer_identity
}

### Billing Monitor
# billing-monitor は ureuzy-org-system をクォータプロジェクトにして、このプロジェクトでクエリジョブを実行する
resource "google_project_iam_member" "billing_monitor" {
  for_each = toset([
    "roles/bigquery.dataViewer",
    "roles/bigquery.jobUser",
    "roles/serviceusage.serviceUsageConsumer",
  ])
  project = google_project.org_system.project_id
  role    = each.value
  member  = "serviceAccount:${data.google_service_account.billing_monitor.email}"
}

### common-api
# 管理者だけの API (べんり) で、アプリと同じく Firestore の allowed_users の role を読むため
resource "google_project_iam_member" "common_api_firestore" {
  project = google_project.ureuzy.project_id
  role    = "roles/datastore.viewer"
  member  = "serviceAccount:${data.google_service_account.common_api.email}"
}

# 見守りカメラ: カメラ役のスマホが子どもの泣き声・声を聞いたら、家族のスマホにプッシュ通知を送るため (Firebase Cloud Messaging)
resource "google_project_iam_member" "common_api_fcm" {
  project = google_project.ureuzy.project_id
  role    = "roles/firebasecloudmessaging.admin"
  member  = "serviceAccount:${data.google_service_account.common_api.email}"
}

# システム管理の「外部サービスの使用量」で、今月の料金と Google マップの回数を請求データから読むため。
# 読むのは請求データのデータセットだけ。クエリは billing-monitor と同じく、このプロジェクトで実行する
resource "google_bigquery_dataset_iam_member" "common_api_billing_export" {
  project    = google_project.org_system.project_id
  dataset_id = google_bigquery_dataset.billing_export.dataset_id
  role       = "roles/bigquery.dataViewer"
  member     = "serviceAccount:${data.google_service_account.common_api.email}"
}

resource "google_project_iam_member" "common_api_billing_query" {
  for_each = toset([
    "roles/bigquery.jobUser",
    "roles/serviceusage.serviceUsageConsumer",
  ])
  project = google_project.org_system.project_id
  role    = each.value
  member  = "serviceAccount:${data.google_service_account.common_api.email}"
}
