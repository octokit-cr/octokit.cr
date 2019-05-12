module Octokit
  module Models
    struct AccessToken
      Octokit.rest_model(
        access_token: String,
        token_type: String,

        # Can be received with a modified accept header
        scope: String?
      )
    end
  end
end
