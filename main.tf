module "organization" {
  source                        = "./org"
  billing_account               = data.sops_file.sops.data["billing_account"]
  allowed_policy_member_domains = ["C03mi6sms"]
}