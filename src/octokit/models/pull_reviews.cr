module Octokit
  module Models
    struct PullRequestReview
      rest_model(
        id: Int64,
        node_id: String,
        user: User,
        body: String,
        submitted_at: String,
        commit_id: String,
        html_url: String,
        pull_request_url: String,
        state: String
      )
    end

    struct DraftReviewComment
      rest_model(
        path: String,
        position: Int32,
        body: String
      )
    end

    struct PullRequestReviewRequest
      rest_model(
        node_id: String,
        commit_id: String,
        body: String,
        event: String,
        comments: Array(DraftReviewComment)
      )
    end

    struct PullRequestReviewDismissalRequest
      rest_model(
        message: String
      )
    end
  end
end
