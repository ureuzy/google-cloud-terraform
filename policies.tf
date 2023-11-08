resource "google_tags_tag_key" "all_users_ingress" {
  parent      = data.google_organization.ureuzy.name
  short_name  = "allUsersIngress"
  description = "All users ingress"
}

resource "google_tags_tag_value" "all_users_ingress" {
  parent      = google_tags_tag_key.all_users_ingress.id
  short_name  = "true"
  description = "Allowed all users ingress"
}

resource "google_tags_location_tag_binding" "binding" {
  parent = "//run.googleapis.com/projects/ureuzy-org-system/locations/asia-northeast1/services/audit-alert"
  tag_value = "tagValues/${google_tags_tag_value.all_users_ingress.name}"
  location  = "asia-northeast1"
}

module "allowed_policy_member_domains" {
  source = "terraform-google-modules/org-policy/google//modules/org_policy_v2"

  policy_root    = "organization"
  policy_root_id = data.google_organization.ureuzy.org_id
  constraint     = "constraints/iam.allowedPolicyMemberDomains"
  policy_type    = "list"
  rules          = [
    {
      enforcement = true
      allow       = ["C03mi6sms"]
      deny        = []
      conditions  = []
    },
    {
      enforcement = true
      allow       = ["C03mi6sms"]
      deny        = []
      conditions  = [
        {
          description = "Allowed all users ingress"
          expression  = "resource.matchTagId('${google_tags_tag_key.all_users_ingress.id}', '${google_tags_tag_value.all_users_ingress.id}')"
          location    = "all-users-ingress.log"
          title       = "Allowed all users ingress"
        }
      ]
    }
  ]
}

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

#resource "google_tags_tag_key" "ignore_wi_pool_providers" {
#  parent      = data.google_organization.ureuzy.name
#  short_name  = "ignoreWorkloadIdentityPoolProviders"
#  description = "Ignore external identity providers policy restrictions"
#}
#
#resource "google_tags_tag_value" "ignore_wi_pool_providers" {
#  parent      = google_tags_tag_key.ignore_wi_pool_providers.id
#  short_name  = "true"
#  description = "Ignore external identity providers policy restrictions"
#}

module "allowed_external_identity_providers" {
  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version = "5.2.2"

  policy_root    = "organization"
  policy_root_id = data.google_organization.ureuzy.org_id
  constraint     = "constraints/iam.workloadIdentityPoolProviders"
  policy_type    = "list"
  exclude_projects = [google_project.org_system.project_id]
  rules          = [
    {
      enforcement = false
      allow       = []
      deny        = []
      conditions  = []
    }
  ]
}

module "cloudfunctions_allowed_ingress_settings" {
  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version = "5.2.2"

  policy_root    = "organization"
  policy_root_id = data.google_organization.ureuzy.org_id
  constraint     = "constraints/cloudfunctions.allowedIngressSettings"
  policy_type    = "list"
  rules          = [
    {
      enforcement = true
      allow       = ["ALLOW_ALL"]
      deny        = []
      conditions  = []
    },
    {
      enforcement = false
      allow       = []
      deny        = []
      conditions  = [
        {
          description = "Allowed all users ingress"
          expression  = "resource.matchTagId('${google_tags_tag_key.all_users_ingress.id}', '${google_tags_tag_value.all_users_ingress.id}')"
          location    = "all-users-ingress.log"
          title       = "Allowed all users ingress"
        }
      ]
    }
  ]
}