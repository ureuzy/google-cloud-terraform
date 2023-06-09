module "organization" {
  source                        = "./org"
  billing_account               = data.sops_file.sops.data["billing_account"]
}