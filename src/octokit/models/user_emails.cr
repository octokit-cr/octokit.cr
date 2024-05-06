require "../helpers"

module Octokit
  module Models
    struct UserEmail
      Octokit.rest_model(
        email: String,
        primary: Bool,
        verified: Bool,
        visibility: String?
      )
    end
  end
end
