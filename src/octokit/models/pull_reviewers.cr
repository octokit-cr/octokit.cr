module Octokit
  module Models
    struct ReviewersRequest
      Octokit.rest_model(
        node_id: String,
        reviewers: Array(String),
        team_reviewers: Array(String)
      )
    end

    struct Reviewers
      Octokit.rest_model(
        users: User,
        teams: Team
      )
    end
  end
end
