module Octokit
  module Models
    struct Apps
      rest_model(
        id: Int64,
        node_id: String,
        owner: User,
        name: String,
        description: String,
        external_url: String,
        html_url: String,
        created_at: String,
        updated_at: String
      )
    end

    struct InstallationToken
      rest_model(
        token: String,
        expires_at: String
      )
    end

    struct InstallationPermissions
      rest_model(
        metadata: String,
        contents: String,
        issues: String,
        single_file: String
      )
    end

    struct Installation
      rest_model(
        id: Int64,
        app_id: Int64,
        target_id: Int64,
        account: User,
        access_tokens_url: String,
        repositories_url: String,
        html_url: String,
        target_type: String,
        single_file_name: String,
        repository_selection: String,
        events: Array(String),
        permissions: InstallationPermissions,
        created_at: String,
        updated_at: String
      )
    end

    struct Attachment
      rest_model(
        id: Int64,
        title: String,
        body: String
      )
    end
  end
end
