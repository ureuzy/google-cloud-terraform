data "sops_file" "sops" {
  source_file = "secrets.yaml"
}