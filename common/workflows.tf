# Workflows のサービスエージェントは、API を有効にしただけではすぐにできず、ワークフローを作ると
# 「Workflows service agent does not exist」で断られる。先に作らせる
resource "google_project_service_identity" "workflows" {
  provider = google-beta
  project  = data.google_project.main.project_id
  service  = "workflows.googleapis.com"

  depends_on = [module.project-services]
}

# 写真の取り込みと解析 (中身と理由は workflows/photo-pipeline.yaml)。0:00 に Scheduler が起こす。アプリのシステム管理からも動かせる
resource "google_workflows_workflow" "photo_pipeline" {
  name            = "photo-pipeline"
  region          = "asia-northeast1"
  description     = "みてねから取り込み、終わったら写っているものと顔を調べる"
  service_account = google_service_account.service_accounts["photo-pipeline"].id
  call_log_level  = "LOG_ERRORS_ONLY"
  source_contents = file("${path.module}/workflows/photo-pipeline.yaml")

  depends_on = [module.project-services, google_project_service_identity.workflows]
}
