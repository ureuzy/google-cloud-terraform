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

module "allowed_ingress_settings" {
  source = "terraform-google-modules/org-policy/google//modules/org_policy_v2"

  policy_root    = "organization"
  policy_root_id = data.google_organization.ureuzy.org_id
  constraint     = "constraints/cloudfunctions.allowedIngressSettings"
  policy_type    = "list"
  rules = [
    {
      enforcement = true
      allow       = []
      deny        = []
      conditions  = []
    }
  ]
}

module "restricting_resource_for_system_project" {
  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version = "5.2.2"

  policy_root    = "organization"
  policy_root_id = data.google_organization.ureuzy.org_id
  constraint     = "constraints/gcp.restrictServiceUsage"
  policy_type    = "list"
  rules = [
    {
      enforcement = true
      allow = [
        "clouddebugger.googleapis.com",
        "cloudkms.googleapis.com",
        "cloudtrace.googleapis.com",
        "datastore.googleapis.com",
        "storage.googleapis.com"
      ]
      deny = []
      conditions = [{
        description = "Limit resources used by system projects"
        expression  = "resource.matchTag('948429943190/project', 'system')"
        location    = ""
        title       = "Limit resources used by system projects"
      }]
    }
  ]
}