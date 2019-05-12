module Octokit
  module Models
    struct InteractionsRestriction
      Octokit.rest_model(
        limit: String,

        origin: String,

        expires_at: String
      )
    end
  end
end
