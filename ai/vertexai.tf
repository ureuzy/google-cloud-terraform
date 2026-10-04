# 生成 AI のキャッシュを止める。おでかけの調査や写真の AI 加工で送った写真・文章を、Google 側に残さない
# (Gemini 3.x 以降は、何もしないと長期のキャッシュが有効になる)
resource "google_vertex_ai_cache_config" "main" {
  project       = data.google_project.main.project_id
  disable_cache = true
}
