module Octokit
  module Models
    struct RepositoryRelease
      Octokit.rest_model(
        tag_name: String,
        target_commitish: String,
        name: String,
        body: String,
        draft: Bool,
        prerelease: Bool,

        id: Int64?,
        created_at: {type: Time?, converter: Time::ISO8601Converter},
        published_at: String?,
        url: String?,
        html_url: String?,
        assets_url: String?,
        assets: Array(ReleaseAsset)?,
        upload_url: String,
        zipball_url: String?,
        tarball_url: String?,
        author: User?,
        node_id: String?
      )
    end

    struct ReleaseAsset
      Octokit.rest_model(
        id: Int32,
        url: String,
        name: String,
        label: String?,
        state: String,
        content_type: String,
        size: Int32,
        download_count: Int32,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        updated_at: {type: Time, converter: Time::ISO8601Converter},
        browser_download_url: String,
        uploader: User,
        node_id: String
      )
    end

    struct RepositoryReleaseRequest
      Octokit.rest_model(
        tag_name: String,
        target_commit_hash: String,
        name: String,
        body: String,
        draft: Bool,
        prerelease: Bool
      )
    end
  end
end
