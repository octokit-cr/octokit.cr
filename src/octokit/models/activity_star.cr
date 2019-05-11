module Octokit
  module Models
    struct ActivityStar
      FIELDS = {
        starred_at: Timestamp,
        repository: Repository,
      }

      rest_model(FIELDS)
    end

    struct Stargazer
      FIELDS = {
        starred_at: Timestamp,
        user:       User,
      }

      rest_model(FIELDS)
    end
  end
end
