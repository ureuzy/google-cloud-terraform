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

module "allowed_policy_member_domains" {
  source = "terraform-google-modules/org-policy/google//modules/org_policy_v2"

  policy_root    = "organization"
  policy_root_id = data.google_organization.ureuzy.org_id
  constraint     = "constraints/iam.allowedPolicyMemberDomains"
  policy_type    = "list"
  exclude_projects = [google_project.konotalos.project_id]
  rules = [
    {
      enforcement = true
      allow       = ["C03mi6sms"]
      deny        = []
      conditions  = []
    },
    {
      enforcement = false
      allow       = []
      deny        = []
      conditions = [
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

module "allowed_external_identity_providers" {
  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version = "5.2.2"

  policy_root      = "organization"
  policy_root_id   = data.google_organization.ureuzy.org_id
  constraint       = "constraints/iam.workloadIdentityPoolProviders"
  policy_type      = "list"
  exclude_projects = [google_project.wi_provider_mgmt.project_id]
  rules = [
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
  rules = [
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
      conditions = [
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

module "disable_automatic_iam_grants" {
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