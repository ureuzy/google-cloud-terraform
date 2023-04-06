#module "org-policy" {
#  source = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
#
#  policy_root    = "organization"
#  policy_root_id = data.google_organization.ureuzy.org_id
#  constraint     = "constraints/iam.allowedPolicyMemberDomains"
#  policy_type    = "list"
#  rules = [
#    {
#      enforcement = true
#      allow       = ["ureuzy.io"]
#      deny        = []
#      conditions  = []
#    }
#  ]
#}