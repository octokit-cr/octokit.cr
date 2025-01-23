module Octokit
  module Models
    struct PullRequestComment
      Octokit.rest_model(
        id: Int64,
        node_id: String,
        in_reply_to: Int64?,
        body: String,
        path: String,
        diff_hunk: String,
        pull_request_review_id: Int64,
        position: Int32,
        original_position: Int32,
        commit_id: String,
        original_commit_id: String,
        user: User,
        reactions: Reactions,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        updated_at: {type: Time, converter: Time::ISO8601Converter},

        author_association: String,
        url: String,
        html_url: String,
        pull_request_url: String
      )
    end

    struct PullRequestListCommentOptions
      Octokit.rest_model({
        sort: String,

        direction: String,

        since: String,
        # }.merge(ListOptions::FIELDS))
      })
    end
  end
end
