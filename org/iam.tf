#resource "google_organization_iam_member" "gcp-owners" {
#  org_id = data.google_organization.ureuzy.org_id
#  role   = "roles/owner"
#  member = "group:gcp-owners@ureuzy.io"
#}

#resource "google_organization_iam_member" "gcp-organization-admins" {
#  org_id = data.google_organization.ureuzy.org_id
#  role   = "roles/cloudsupport.admin"
#  member = "group:gcp-organization-admins@ureuzy.io"
#}

#resource "google_organization_iam_member" "test" {
#  for_each = toset([
#    "roles/owner",
#    "roles/editor",
#    "roles/browser"
#  ])
#  org_id = data.google_organization.ureuzy.org_id
#  role   = each.key
#  member = "user:admin@ureuzy.io"
#}