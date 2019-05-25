module Octokit
  module Models
    struct TeamDiscussion
      Octokit.rest_model(
        author: User,
        body: String,
        body_html: String,
        body_version: String,
        comments_count: Int32,
        comments_url: String,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        last_edited_at: String,
        html_url: String,
        node_id: String,
        number: Int32,
        pinned: Bool,
        private: Bool,
        team_url: String,
        title: String,
        updated_at: {type: Time, converter: Time::ISO8601Converter},
        url: String,
        reactions: Reactions
      )
    end

    struct DiscussionListOptions
      Octokit.rest_model(
        direction: String
      )
    end
  end
end
