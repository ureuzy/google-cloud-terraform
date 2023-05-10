#module "allowed_policy_member_domains" {
#  source = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
#
#  policy_root    = "organization"
#  policy_root_id = data.google_organization.ureuzy.org_id
#  constraint     = "constraints/iam.allowedPolicyMemberDomains"
#  policy_type    = "list"
#  rules = [
#    {
#      enforcement = true
#      allow       = var.allowed_policy_member_domains
#      deny        = []
#      conditions  = []
#    }
#  ]
#}

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

module "skip_default_network_creation" {
  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version = "5.2.2"

  policy_root    = "organization"
  policy_root_id = data.google_organization.ureuzy.org_id
  constraint     = "constraints/compute.skipDefaultNetworkCreation"
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

module "automatic_iam_grants_default_service_accounts" {
  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version = "5.2.2"

  policy_root    = "organization"
  policy_root_id = data.google_organization.ureuzy.org_id
  constraint     = "constraints/iam.automaticIamGrantsForDefaultServiceAccounts"
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

#module "restrict_resources_to_system_project" {
#  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
#  version = "5.2.2"
#
#  policy_root    = "organization"
#  policy_root_id = data.google_organization.ureuzy.org_id
#  constraint     = "constraints/gcp.restrictServiceUsage"
#  policy_type    = "list"
#  rules = [
#    {
#      enforcement = true
#      allow = [
#        "cloudkms.googleapis.com",
#        "storage.googleapis.com"
#      ]
#      deny = []
#      conditions = [{
#        description = "Limit resources used by system projects"
#        expression  = "resource.matchTag('${data.google_organization.ureuzy.org_id}/project', 'system')"
#        location    = ""
#        title       = "Limit resources used by system projects"
#      }]
#    },
#  ]
#}
#
#module "restrict_resources_to_system_project_folder" {
#  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
#  version = "5.2.2"
#
#  policy_root     = "organization"
#  policy_root_id  = data.google_organization.ureuzy.org_id
#  constraint      = "constraints/gcp.restrictServiceUsage"
#  policy_type     = "list"
#  exclude_folders = [data.google_folder.sample.folder_id]
#  rules = [
#    {
#      enforcement = false
#      allow       = []
#      deny        = ["bigqueryreservation.googleapis.com"]
#      conditions  = []
#    }
#  ]
#}