module Octokit
  module Models
    struct Timeline
      Octokit.rest_model(
        id: Int64,
        url: String,
        commit_url: String,

        actor: User,

        event: String,

        commit_id: String,

        created_at: {type: Time, converter: Time::ISO8601Converter},

        label: Label?,

        assignee: User?,

        milestone: User?,

        source: Source?,

        rename: Rename?,
        project_card: ProjectCard?
      )
    end

    struct Source
      Octokit.rest_model(
        id: Int64,
        url: String,
        actor: User,
        type: String,
        issue: Issue
      )
    end
  end
end
