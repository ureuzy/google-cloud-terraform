# organization

Organization-level resources for GCP.

- **Project**: `ureuzy-org-system`
- **Workspace**: `google-cloud-terraform`

## Resources

| File | Description |
|------|-------------|
| projects.tf | GCP project definitions and API enablement |
| organizationpolicies.tf | Organization policies (tag-based exceptions) |
| workloadidentity.tf | Workload Identity Federation (GitHub Actions, Terraform Cloud) |
| billingbudget.tf | Billing budgets and alerts |
| logging.tf | Organization-level logging |
| bigquery.tf | BigQuery datasets for logs/billing |
| iam.tf | IAM bindings |
| serviceaccounts.tf | Service accounts |
