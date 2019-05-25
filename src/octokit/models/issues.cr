module Octokit
  module Models
    struct Issue
      Octokit.rest_model(
        id: Int64,
        number: Int32,
        state: String,
        locked: Bool,
        title: String,
        body: String?,
        user: User,
        labels: Array(Label)?,
        assignee: User?,
        comments: Int32,
        closed_at: String?,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        updated_at: {type: Time?, converter: Time::ISO8601Converter},
        closed_by: User?,
        url: String,
        html_url: String,
        comments_url: String,
        events_url: String,
        labels_url: String,
        repository_url: String,
        milestone: Milestone?,
        pull_request_links: PullRequestLinks?,
        repository: Repository?,
        reactions: Reactions?,
        assignees: Array(User),
        node_id: String,

        text_matches: Array(TextMatch)?,

        active_lock_reason: String?
      )
    end

    struct IssueRequest
      Octokit.rest_model(
        title: String,
        body: String,
        labels: Array(String),
        assignee: String,
        state: String,
        milestone: Int32,
        assignees: Array(String)
      )
    end

    struct IssueListOptions
      Octokit.rest_model({
        filter: String,

        state: String,

        labels: Array(String),

        sort: String,

        direction: String,

        since: String,
        # }.merge(ListOptions::FIELDS))
      })
    end

    struct PullRequestLinks
      Octokit.rest_model(
        url: String,
        html_url: String,
        diff_url: String,
        patch_url: String
      )
    end
  end
end
