module Octokit
  module Models
    struct UserEmaul
      rest_model(
        email: String,
        primary: Bool,
        verified: Bool
      )
    end
  end
end
