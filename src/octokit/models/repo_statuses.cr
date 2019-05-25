module Octokit
  module Models
    struct RepoStatus
      Octokit.rest_model(
        url: String,
        avatar_id: String?,
        id: Int32,
        node_id: String,
        state: String,
        description: String,
        target_url: String?,
        context: String,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        updated_at: {type: Time, converter: Time::ISO8601Converter},
        creator: User?
      )
    end

    struct CombinedStatus
      Octokit.rest_model(
        state: String,
        statuses: Array(RepoStatus),
        sha: String,
        total_count: Int32,
        repository: Repository,
        commit_url: String,
        url: String
      )
    end
  end
end
