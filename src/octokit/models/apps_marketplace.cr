module Octokit
  module Models
    struct MarketplacePlan
      Octokit.rest_model(
        url: String,
        accounts_url: String,
        id: Int64,
        name: String,
        description: String,
        monthly_price_in_cents: Int32,
        yearly_price_in_cents: Int32,

        # The pricing model for this listing. Can be one of "flat-rate", "per-unit", or "free"
        # TODO: Make an Enum eventually
        price_model: String,

        unit_name: String,
        bullets: Array(String),

        # State can be one of "draft" or "published"
        state: String,

        has_free_trial: Bool
      )
    end

    class MarketplacePurchase
      # Created as a class to prevent recursive struct
      Octokit.rest_model(
        # Billing cycle can be one of "yearly", "monthly", or `nil`.
        billing_cycle: String?,

        next_billing_date: String?,
        unit_count: Int32,
        plan: MarketplacePlan,
        account: MarketplacePlanAccount,
        on_free_trial: Bool,
        free_trial_ends_on: String?
      )
    end

    struct MarketplacePendingChange
      Octokit.rest_model(
        effective_date: String,
        unit_count: Int32,
        id: Int64,
        plan: MarketplacePlan
      )
    end

    struct MarketplacePlanAccount
      Octokit.rest_model(
        url: String,
        type: String,
        id: Int64,
        node_id: String,
        login: String,
        email: String,
        organization_billing_email: String,
        marketplace_purchase: MarketplacePurchase,
        marketplace_pending_change: MarketplacePendingChange
      )
    end
  end
end
