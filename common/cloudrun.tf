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

resource "google_cloud_run_v2_job" "ai_reporter" {
  name                = "ai-reporter"
  location            = "asia-northeast1"
  deletion_protection = false

  template {
    template {
      containers {
        image = "asia-northeast1-docker.pkg.dev/${data.google_project.main.project_id}/cloud-run-source-deploy/ai-reporter:latest"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      template[0]
    ]
  }
}

# define: https://github.com/ureuzy/cloud_functions/blob/main/ai-reporter/job.yaml
import {
  id = "projects/ureuzy-common/locations/asia-northeast1/jobs/ai-reporter"
  to = google_cloud_run_v2_job.ai_reporter
}

# resource "google_cloud_run_v2_job" "ai_sensei_daily_poster" {
#   name                = "ai-sensei-daily-poster"
#   location            = "asia-northeast1"
#   deletion_protection = false
#   template {
#     template {}
#   }
#   lifecycle {
#     ignore_changes = [
#       template[0]
#     ]
#   }
# }
# # define: https://github.com/ureuzy/cloud_functions/blob/main/ai-sensei/daily-poster/job.yaml
# import {
#   id = "projects/ureuzy-common/locations/asia-northeast1/jobs/ai-sensei-daily-poster"
#   to = google_cloud_run_v2_job.ai_sensei_daily_poster
# }

# resource "google_cloud_run_v2_service" "ai_sensei_event_handler" {
#   name                = "ai-sensei-event-handler"
#   location            = "asia-northeast1"
#   ingress             = "INGRESS_TRAFFIC_ALL"
#   deletion_protection = false
#   template {}
#   lifecycle {
#     ignore_changes = [
#       client,
#       client_version,
#       template[0]
#     ]
#   }
# }
# # define: https://github.com/ureuzy/cloud_functions/blob/main/ai-sensei/event-handler/service.yaml
# import {
#   id = "projects/ureuzy-common/locations/asia-northeast1/services/ai-sensei-event-handler"
#   to = google_cloud_run_v2_service.ai_sensei_event_handler
# }
