resource "google_organization_iam_member" "admin" {
  for_each = toset([
    "roles/owner"
  ])
  org_id = data.google_organization.ureuzy.org_id
  role   = each.key
  member = "user:admin@ureuzy.io"
}