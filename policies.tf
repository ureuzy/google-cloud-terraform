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
#      allow       = ["C03mi6sms"]
#      deny        = []
#      conditions  = []
#    }
#  ]
#}

#module "allowed_service_usage" {
#  source = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
#
#  policy_root    = "project"
#  policy_root_id = google_project.org_system.project_id
#  constraint     = "constraints/gcp.restrictServiceUsage"
#  policy_type    = "list"
#  rules = [
#    {
#      enforcement = true
#      allow       = [
#        "cloudkms.googleapis.com",
#        "storage.googleapis.com",
#        "cloudbuild.googleapis.com",
#        "cloudfunctions.googleapis.com",
#        "pubsub.googleapis.com",
#        "run.googleapis.com",
#        "eventarc.googleapis.com",
#        "artifactregistry.googleapis.com",
#        "secretmanager.googleapis.com"
#      ]
#      deny        = []
#      conditions  = []
#    }
#  ]
#}

module "cloudfunctions_allowed_ingress_settings" {
  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version = "5.2.2"

  policy_root    = "organization"
  policy_root_id = data.google_organization.ureuzy.org_id
  constraint     = "constraints/cloudfunctions.allowedIngressSettings"
  policy_type    = "list"
  rules = [
    {
      enforcement = true
      allow       = ["ALLOW_ALL", "ALLOW_INTERNAL_ONLY"]
      deny        = []
      conditions  = []
    }
  ]
}