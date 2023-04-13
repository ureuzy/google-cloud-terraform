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
      enforcement = false
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
      allow       = ["ALLOW_INTERNAL_AND_GCLB"]
      deny        = []
      conditions  = []
    }
  ]
}

#module "allowed_services" {
#  source = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
#
#  policy_root    = "organization"
#  policy_root_id = data.google_organization.ureuzy.org_id
#  constraint     = "constraints/serviceuser.services"
#  policy_type    = "list"
#  rules = [
#    {
#      enforcement = true
#      allow = [
#        "appengine.googleapis.com",
#        "artifactregistry.googleapis.com",
#        "bigquery.googleapis.com",
#        "bigquerymigration.googleapis.com",
#        "bigquerystorage.googleapis.com",
#        "billingbudgets.googleapis.com",
#        "cloudapis.googleapis.com",
#        "cloudbilling.googleapis.com",
#        "cloudbuild.googleapis.com",
#        "clouddebugger.googleapis.com",
#        "cloudfunctions.googleapis.com",
#        "cloudkms.googleapis.com",
#        "cloudresourcemanager.googleapis.com",
#        "cloudtrace.googleapis.com",
#        "containerregistry.googleapis.com",
#        "datastore.googleapis.com",
#        "fcm.googleapis.com",
#        "fcmregistrations.googleapis.com",
#        "firebase.googleapis.com",
#        "firebaseappdistribution.googleapis.com",
#        "firebasedatabase.googleapis.com",
#        "firebasedynamiclinks.googleapis.com",
#        "firebasehosting.googleapis.com",
#        "firebaseinstallations.googleapis.com",
#        "firebaseremoteconfig.googleapis.com",
#        "firebaserules.googleapis.com",
#        "iamcredentials.googleapis.com",
#        "identitytoolkit.googleapis.com",
#        "logging.googleapis.com",
#        "mobilecrashreporting.googleapis.com",
#        "monitoring.googleapis.com",
#        "orgpolicy.googleapis.com",
#        "pubsub.googleapis.com",
#        "runtimeconfig.googleapis.com",
#        "securetoken.googleapis.com",
#        "servicemanagement.googleapis.com",
#        "serviceusage.googleapis.com",
#        "source.googleapis.com",
#        "sql-component.googleapis.com",
#        "storage-api.googleapis.com",
#        "storage-component.googleapis.com",
#        "storage.googleapis.com",
#        "testing.googleapis.com",
#      ]
#      deny       = []
#      conditions = []
#    }
#  ]
#}