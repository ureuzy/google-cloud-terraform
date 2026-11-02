# 写真の取り込みと解析 (中身と理由は workflows/photo-pipeline.yaml)。0:00 に Scheduler が起こす。アプリのシステム管理からも動かせる
resource "google_workflows_workflow" "photo_pipeline" {
  name            = "photo-pipeline"
  region          = "asia-northeast1"
  description     = "みてねから取り込み、終わったら写っているものと顔を調べる"
  service_account = google_service_account.service_accounts["photo-pipeline"].id
  call_log_level  = "LOG_ERRORS_ONLY"
  source_contents = file("${path.module}/workflows/photo-pipeline.yaml")

  depends_on = [module.project-services]
}
