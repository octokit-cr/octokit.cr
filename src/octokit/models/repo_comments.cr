module Octokit
  module Models
    struct RepositoryComment
      rest_model(
        html_url: String,
        url: String,
        id: Int64,
        commit_id: String,
        user: User,
        reactions: Reactions,
        created_at: String,
        updated_at: String,

        body: String,

        path: String,
        position: Int32
      )
    end
  end
end
