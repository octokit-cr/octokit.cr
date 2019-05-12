module Octokit
  module Models
    struct WebHookPayload
      rest_model(
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
      rest_model(
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
      rest_model(
        email: String,
        name: String,
        username: String
      )
    end

    struct Hook
      rest_model(
        created_at: String,
        updated_at: String,
        url: String,
        id: Int64,

        config: Hash(String, String),
        events: Array(String),
        active: Bool
      )
    end

    struct CreateHookRequest
      rest_model(
        name: String?,
        config: Hash(String, String)?,
        events: Array(String)?,
        active: Bool?
      )
    end
  end
end
