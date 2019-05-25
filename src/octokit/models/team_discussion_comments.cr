module Octokit
  module Models
    struct DiscussionComment
      Octokit.rest_model(
        author: User,
        body: String,
        body_html: String,
        body_version: String,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        last_edited_at: String,
        discussion_url: String,
        html_url: String,
        node_id: String,
        number: Int32,
        updated_at: {type: Time, converter: Time::ISO8601Converter},
        url: String,
        reactions: Reactions
      )
    end

    struct DiscussionCommentListOptions
      Octokit.rest_model(
        direction: String
      )
    end
  end
end
