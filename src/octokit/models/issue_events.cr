module Octokit
  module Models
    struct IssueEvent
      rest_model(
        id: Int64,
        url: String,

        actor: User,

        event: String,

        created_at: String,
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
      rest_model(
        state: String,
        review_id: Int64,
        dismissal_message: String,
        dismissal_commit_id: String
      )
    end
  end
end
