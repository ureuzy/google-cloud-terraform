data "google_billing_account" "account" {
  billing_account = "0180E6-1F523F-8A7E63"
}

resource "google_billing_budget" "budget" {
  billing_account = data.google_billing_account.account.id
  display_name = "Example Billing Budget"
  amount {
    specified_amount {
      currency_code = "JPY"
      units = "100000"
    }
  }
  threshold_rules {
    threshold_percent =  0.5
  }
  budget_filter {
    calendar_period = "MONTH"
  }
}