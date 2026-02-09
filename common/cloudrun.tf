resource "google_cloud_run_v2_job" "mitene_downloader" {
  name                = "mitene-downloader"
  location            = "asia-northeast1"
  deletion_protection = false
  template {
    template {}
  }
  lifecycle {
    ignore_changes = [
      template[0]
    ]
  }
}
# define: https://github.com/ureuzy/cloud_functions/blob/main/mitene-downloader/job.yaml
import {
  id = "projects/ureuzy-common/locations/asia-northeast1/jobs/mitene-downloader"
  to = google_cloud_run_v2_job.mitene_downloader
}

resource "google_cloud_run_v2_job" "billing_monitor" {
  name                = "billing-monitor"
  location            = "asia-northeast1"
  deletion_protection = false
  template {
    template {}
  }
  lifecycle {
    ignore_changes = [
      template[0]
    ]
  }
}
# define: https://github.com/ureuzy/cloud_functions/blob/main/billing-monitor/job.yaml
import {
  id = "projects/ureuzy-common/locations/asia-northeast1/jobs/billing-monitor"
  to = google_cloud_run_v2_job.billing_monitor
}

resource "google_cloud_run_v2_job" "activity_analyzer" {
  name                = "activity-analyzer"
  location            = "asia-northeast1"
  deletion_protection = false
  template {
    template {}
  }
  lifecycle {
    ignore_changes = [
      template[0]
    ]
  }
}
# define: https://github.com/ureuzy/cloud_functions/blob/main/activity-analyzer/job.yaml
import {
  id = "projects/ureuzy-common/locations/asia-northeast1/jobs/activity-analyzer"
  to = google_cloud_run_v2_job.activity_analyzer
}

resource "google_cloud_run_v2_service" "audit_alert" {
  name                = "audit-alert"
  location            = "asia-northeast1"
  ingress             = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  deletion_protection = false
  template {}
  lifecycle {
    ignore_changes = [
      client,
      client_version,
      template[0]
    ]
  }
}
# define: https://github.com/ureuzy/cloud_functions/blob/main/audit-alert/service.yaml
import {
  id = "projects/ureuzy-common/locations/asia-northeast1/services/audit-alert"
  to = google_cloud_run_v2_service.audit_alert
}

resource "google_cloud_run_v2_service" "common_api" {
  name                = "common-api"
  location            = "asia-northeast1"
  ingress             = "INGRESS_TRAFFIC_ALL"
  deletion_protection = false
  template {}
  lifecycle {
    ignore_changes = [
      client,
      client_version,
      template[0]
    ]
  }
}
# define: https://github.com/ureuzy/cloud_functions/blob/main/common-api/service.yaml
import {
  id = "projects/ureuzy-common/locations/asia-northeast1/services/common-api"
  to = google_cloud_run_v2_service.common_api
}

resource "google_cloud_run_v2_job" "ai_web_summarizer" {
  name                = "ai-web-summarizer"
  location            = "asia-northeast1"
  deletion_protection = false
  template {
    template {}
  }
  lifecycle {
    ignore_changes = [
      template[0]
    ]
  }
}
# define: https://github.com/ureuzy/cloud_functions/blob/main/ai-web-summarizer/job.yaml
import {
  id = "projects/ureuzy-common/locations/asia-northeast1/jobs/ai-web-summarizer"
  to = google_cloud_run_v2_job.ai_web_summarizer
}
