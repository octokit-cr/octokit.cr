module Octokit
  module Models
    struct InteractionsRestriction
      rest_model(
        limit: String,

        origin: String,

        expires_at: Timestamp
      )
    end
  end
end
