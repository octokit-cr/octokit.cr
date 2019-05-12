module Octokit
  module Models
    struct RepoStatus
      rest_model(
        id: Int64,
        node_id: String,
        url: String,

        state: String,

        target_url: String,

        description: String,

        context: String,

        creator: User,
        created_at: String,
        updated_at: String
      )
    end

    struct CombinedStatus
      rest_model(
        state: String,

        name: String,
        sha: String,
        total_count: Int32,
        statuses: Array(RepoStatus),

        commit_url: String,
        repository_url: String
      )
    end
  end
end
