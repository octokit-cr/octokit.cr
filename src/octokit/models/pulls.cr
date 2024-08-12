require "../core_ext/time"
require "./issue_labels"

module Octokit
  module Models
    struct PullRequest
      Octokit.rest_model(
        id: Int64,
        number: Int32,
        state: String,
        title: String,
        body: String?,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        updated_at: {type: Time, converter: Time::ISO8601Converter},
        closed_at: String?,
        merged_at: String?,
        labels: Array(Label)?,
        user: User,
        draft: Bool,
        merged: Bool?,
        mergeable: Bool?,
        mergeable_state: String?,
        merged_by: String?,
        merge_commit_sha: String,
        comments: Int32?,
        commits: Int32?,
        additions: Int32?,
        deletions: Int32?,
        changed_files: Int32?,
        url: String,
        html_url: String,
        issue_url: String,
        statuses_url: String,
        diff_url: String,
        patch_url: String,
        commits_url: String,
        comments_url: String,
        review_comment_url: String,
        review_comments: Int32?,
        assignee: User?,
        assignees: Array(User)?,
        milestone: Milestone?,
        maintainer_can_modify: Bool?,
        author_association: String,
        node_id: String,
        requested_reviewers: Array(User),

        requested_teams: Array(Team),

        links: PRLinks?,
        head: PullRequestBranch,
        base: PullRequestBranch,

        active_lock_reason: String?
      )
    end

    struct PRLink
      Octokit.rest_model(
        href: String
      )
    end

    struct PRLinks
      Octokit.rest_model(
        this: {key: "self", type: PRLink},
        html: PRLink,
        issue: PRLink,
        comments: PRLink,
        review_comments: PRLink,
        review_comment: PRLink,
        commits: PRLink,
        statuses: PRLink
      )
    end

    struct PullRequestBranch
      Octokit.rest_model(
        label: String,
        ref: String,
        sha: String,
        repo: Repository?,
        user: User
      )
    end

    struct PullRequestListOptions
      Octokit.rest_model({
        state:     String,
        head:      String,
        base:      String,
        sort:      String,
        direction: String,
        # }.merge(ListOptions::FIELDS))
      })
    end

    struct NewPullRequest
      Octokit.rest_model(
        title: String,
        head: String,
        base: String,
        body: String,
        issue: Int32,
        maintainer_can_modify: Bool,
        draft: Bool
      )
    end

    struct PullRequestUpdate
      Octokit.rest_model(
        title: String,
        body: String,
        state: String,
        base: String,
        maintainer_can_modify: Bool
      )
    end

    struct PullRequestMergeResult
      Octokit.rest_model(
        sha: String,
        merged: Bool,
        message: String
      )
    end

    struct PullRequestOptions
      Octokit.rest_model(
        commit_title: String,
        sha: String,

        merge_method: String
      )
    end

    struct PullRequestMergeRequest
      Octokit.rest_model(
        commit_message: String,
        commit_title: String,
        merge_method: String,
        sha: String
      )
    end
  end
end
