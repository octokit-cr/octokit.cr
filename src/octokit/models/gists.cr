module Octokit
  module Models
    struct Gists
      Octokit.rest_model(
        id: String,
        description: String,
        public: Bool,
        owner: User,
        files: Hash(String, GistFile),
        comments: Int32,
        html_url: String,
        git_pull_url: String,
        git_push_url: String,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        updated_at: {type: Time, converter: Time::ISO8601Converter},
        node_id: String
      )
    end

    struct GistFile
      Octokit.rest_model(
        size: Int32,
        filename: String,
        language: String,
        type: String,
        raw_url: String,
        content: String
      )
    end

    struct GistFork
      Octokit.rest_model(
        url: String,
        user: User,
        id: String,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        updated_at: {type: Time, converter: Time::ISO8601Converter},
        node_id: String
      )
    end

    struct GistListOptions
      Octokit.rest_model({
        since: String,
        # }.merge(ListOptions::FIELDS))
      })
    end
  end
end
