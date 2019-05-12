module Octokit
  module Models
    struct Issue
      rest_model(
        id: Int64,
        number: Int32,
        state: String,
        locked: Bool,
        title: String,
        body: String,
        user: User,
        labels: Array(Label),
        assignee: User,
        comments: Int32,
        closed_at: String,
        created_at: String,
        updated_at: String,
        closed_by: User,
        url: String,
        html_url: String,
        comments_url: String,
        events_url: String,
        labels_url: String,
        repository_url: String,
        milestone: Milestone,
        pull_request_links: PullRequestLinks,
        repository: Repository,
        reactions: Reactions,
        assignees: Array(User),
        node_id: String,

        text_matches: Array(TextMatch)?,

        active_lock_reason: String?
      )
    end

    struct IssueRequest
      rest_model(
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
      rest_model({
        filter: String,

        state: String,

        labels: Array(String),

        sort: String,

        direction: String,

        since: String,
      }.merge(ListOptions))
    end

    struct PullRequestLinks
      rest_model(
        url: String,
        html_url: String,
        diff_url: String,
        patch_url: String
      )
    end
  end
end
