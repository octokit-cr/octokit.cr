module Octokit
  module Models
    struct Milestone
      Octokit.rest_model(
        url: String,
        html_url: String,
        labels_url: String,
        id: Int64,
        number: Int32,
        state: String,
        title: String,
        description: String?,
        creator: User,
        open_issues: Int32,
        closed_issues: Int32,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        updated_at: {type: Time, converter: Time::ISO8601Converter},
        closed_at: String?,
        due_on: String?,
        node_id: String
      )
    end
  end
end
