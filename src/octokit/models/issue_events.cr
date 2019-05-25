module Octokit
  module Models
    struct IssueEvent
      Octokit.rest_model(
        id: Int64,
        url: String,

        actor: User,

        event: String,

        created_at: {type: Time, converter: Time::ISO8601Converter},
        issue: Issue,

        assignee: User?,
        assigner: User?,
        commit_id: String?,
        milestone: Milestone?,
        label: Label?,
        rename: Rename?,
        lock_reason: String?,
        project_card: ProjectCard?,
        dismissed_review: DismissedReview?
      )
    end

    struct DismissedReview
      Octokit.rest_model(
        state: String,
        review_id: Int64,
        dismissal_message: String,
        dismissal_commit_id: String
      )
    end

    struct Rename
      Octokit.rest_model(
        from: String,
        to: String
      )
    end
  end
end
