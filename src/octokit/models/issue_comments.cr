module Octokit
  module Models
    struct IssueComment
      Octokit.rest_model(
        id: Int64,
        node_id: String,
        body: String,
        user: User,
        reactions: Reactions,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        updated_at: {type: Time, converter: Time::ISO8601Converter},

        author_associations: String?,
        url: String,
        html_url: String,
        issue_url: String
      )
    end
  end
end
