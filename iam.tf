resource "google_organization_iam_member" "admin" {
  for_each = toset([
    "roles/owner"
  ])
  org_id = data.google_organization.ureuzy.org_id
  role   = each.key
  member = "user:admin@ureuzy.io"
}

resource "google_organization_iam_member" "owner" {
  for_each = toset([
    "roles/owner"
  ])
  org_id = data.google_organization.ureuzy.org_id
  role   = each.key
  member = "group:gcp-owners@ureuzy.io"
}

resource "google_organization_iam_member" "billing" {
  for_each = toset([
    "roles/billing.admin",
    "roles/billing.creator",
    "roles/resourcemanager.organizationViewer"
  ])
  org_id = data.google_organization.ureuzy.org_id
  role   = each.key
  member = "group:gcp-billing-admins@ureuzy.io"
}

resource "google_organization_iam_member" "devops" {
  for_each = toset([
    "roles/resourcemanager.folderViewer"
  ])
  org_id = data.google_organization.ureuzy.org_id
  role   = each.key
  member = "group:gcp-devops@ureuzy.io"
}

resource "google_organization_iam_member" "logging" {
  for_each = toset([
    "roles/logging.admin"
  ])
  org_id = data.google_organization.ureuzy.org_id
  role   = each.key
  member = "group:gcp-logging-admins@ureuzy.io"
}

resource "google_organization_iam_member" "monitoring" {
  for_each = toset([
    "roles/monitoring.admin"
  ])
  org_id = data.google_organization.ureuzy.org_id
  role   = each.key
  member = "group:gcp-monitoring-admins@ureuzy.io"
}

resource "google_organization_iam_member" "network" {
  for_each = toset([
    "roles/resourcemanager.folderViewer",
    "roles/compute.xpnAdmin",
    "roles/compute.securityAdmin",
    "roles/compute.networkAdmin"
  ])
  org_id = data.google_organization.ureuzy.org_id
  role   = each.key
  member = "group:gcp-network-admins@ureuzy.io"
}

resource "google_organization_iam_member" "organization" {
  for_each = toset([
    "roles/cloudsupport.admin",
    "roles/securitycenter.admin",
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.projectCreator",
    "roles/billing.user",
    "roles/iam.organizationRoleAdmin",
    "roles/resourcemanager.organizationAdmin",
    "roles/orgpolicy.policyAdmin"
  ])
  org_id = data.google_organization.ureuzy.org_id
  role   = each.key
  member = "group:gcp-organization-admins@ureuzy.io"
}

resource "google_organization_iam_member" "security" {
  for_each = toset([
    "roles/compute.viewer",
    "roles/container.viewer",
    "roles/securitycenter.admin",
    "roles/iam.securityReviewer",
    "roles/resourcemanager.folderIamAdmin",
    "roles/logging.privateLogViewer",
    "roles/logging.configWriter",
    "roles/iam.organizationRoleViewer",
    "roles/orgpolicy.policyAdmin"
  ])
  org_id = data.google_organization.ureuzy.org_id
  role   = each.key
  member = "group:gcp-security-admins@ureuzy.io"
}

resource "google_organization_iam_member" "domain" {
  for_each = toset([
    "roles/resourcemanager.projectCreator",
    "roles/billing.creator"
  ])
  org_id = data.google_organization.ureuzy.org_id
  role   = each.key
  member = "domain:ureuzy.io"
}