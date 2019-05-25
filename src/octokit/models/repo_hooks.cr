module Octokit
  module Models
    struct WebHookPayload
      Octokit.rest_model(
        after: String,
        before: String,
        commits: Array(String),
        compare: String,
        created: Bool,
        deleted: Bool,
        forced: Bool,
        head_commit: WebHookCommit,
        pusher: User,
        ref: String,
        repo: Repository,
        sender: User
      )
    end

    struct WebHookCommit
      Octokit.rest_model(
        added: Array(String),
        author: WebHookAuthor,
        committer: WebHookAuthor,
        distinct: Bool,
        id: String,
        message: Array(String),
        modified: Array(String),
        removed: Array(String),
        timestamp: String
      )
    end

    struct WebHookAuthor
      Octokit.rest_model(
        email: String,
        name: String,
        username: String
      )
    end

    struct Hook
      Octokit.rest_model(
        created_at: {type: Time, converter: Time::ISO8601Converter},
        updated_at: {type: Time, converter: Time::ISO8601Converter},
        url: String,
        id: Int64,

        config: Hash(String, String),
        events: Array(String),
        active: Bool
      )
    end

    struct CreateHookRequest
      Octokit.rest_model(
        name: String?,
        config: Hash(String, String)?,
        events: Array(String)?,
        active: Bool?
      )
    end
  end
end
