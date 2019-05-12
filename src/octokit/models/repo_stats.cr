module Octokit
  module Models
    struct ContributorStats
      Octokit.rest_model(
        author: Contributor,
        total: Int32,
        weeks: Array(WeeklyStats)
      )
    end

    struct WeeklyStats
      Octokit.rest_model(
        week: String,
        additions: Int32,
        deletions: Int32,
        commits: Int32
      )
    end

    struct WeeklyCommitActivity
      Octokit.rest_model(
        days: Array(Int32),
        total: Int32,
        week: String
      )
    end

    struct PunchCard
      Octokit.rest_model(
        day: Int32,
        hour: Int32,
        commits: Int32
      )
    end
  end
end
