module "allowed_policy_member_domains" {
  source = "terraform-google-modules/org-policy/google//modules/org_policy_v2"

  policy_root    = "organization"
  policy_root_id = data.google_organization.ureuzy.org_id
  constraint     = "constraints/iam.allowedPolicyMemberDomains"
  policy_type    = "list"
  rules = [
    {
      enforcement = true
      allow       = var.allowed_policy_member_domains
      deny        = []
      conditions  = []
    }
  ]
}

module "restrict_authorized_networks" {
  source = "terraform-google-modules/org-policy/google//modules/org_policy_v2"

  policy_root    = "organization"
  policy_root_id = data.google_organization.ureuzy.org_id
  constraint     = "constraints/sql.restrictAuthorizedNetworks"
  policy_type    = "boolean"
  rules = [
    {
      enforcement = true
      allow       = []
      deny        = []
      conditions  = []
    }
  ]
}