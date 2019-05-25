module Octokit
  module Models
    struct UserMigration
      Octokit.rest_model(
        id: Int64,
        guid: String,

        state: String,

        lock_repositories: Bool,

        exclude_attachments: Bool,
        url: String,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        updated_at: {type: Time, converter: Time::ISO8601Converter},
        repositories: Array(Repository)
      )
    end

    struct UserMigrationOptions
      Octokit.rest_model(
        lock_repositories: Bool?,
        exclude_attachments: Bool?
      )
    end

    struct StartUserMigration
      Octokit.rest_model(
        repositories: Array(String)?,

        lock_repositories: Bool?,

        exclude_attachments: Bool?
      )
    end
  end
end
