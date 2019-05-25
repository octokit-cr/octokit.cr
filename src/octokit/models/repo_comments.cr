module Octokit
  module Models
    struct RepositoryComment
      Octokit.rest_model(
        html_url: String,
        url: String,
        id: Int64,
        commit_id: String,
        user: User,
        reactions: Reactions,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        updated_at: {type: Time, converter: Time::ISO8601Converter},

        body: String,

        path: String,
        position: Int32
      )
    end
  end
end
