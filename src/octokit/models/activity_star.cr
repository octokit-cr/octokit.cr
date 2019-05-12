module Octokit
  module Models
    struct ActivityStar
      FIELDS = {
        starred_at: String,
        repository: Repository,
      }

      rest_model(FIELDS)
    end

    struct Stargazer
      FIELDS = {
        starred_at: String,
        user:       User,
      }

      rest_model(FIELDS)
    end
  end
end
