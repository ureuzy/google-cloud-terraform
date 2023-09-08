data "google_billing_account" "account" {
  billing_account = data.sops_file.sops.data["billing_account"]
}

resource "google_billing_budget" "budget" {
  billing_account = data.google_billing_account.account.id
  display_name    = "Billing Budget"
  amount {
    specified_amount {
      currency_code = "JPY"
      units         = "10000"
    }
  }
  threshold_rules {
    threshold_percent = 0.5
  }
  budget_filter {
    calendar_period = "MONTH"
  }
}