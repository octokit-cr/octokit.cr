module Octokit
  module Models
    struct ActivityStar
      Octokit.rest_model(
        starred_at: String,
        repository: Repository
      )
    end

    struct Stargazer
      Octokit.rest_model(
        starred_at: String,
        user: User
      )
    end
  end
end
