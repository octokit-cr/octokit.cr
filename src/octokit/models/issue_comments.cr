module Octokit
  module Models
    struct IssueComment
      rest_model(
        id: Int64,
        node_id: String,
        body: String,
        user: User,
        reactions: Reactions,
        created_at: String,
        updated_at: String,

        author_associations: String,
        url: String,
        html_url: String,
        issue_url: String
      )
    end
  end
end
