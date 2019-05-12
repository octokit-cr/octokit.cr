module Octokit
  module Models
    struct RepositoryLicense
      Octokit.rest_model(
        name: String,
        path: String,

        sha: String,
        size: Int32,
        url: String,
        html_url: String,
        git_url: String,
        download_url: String,
        type: String,
        content: String,
        encoding: String,
        license: License
      )
    end

    struct License
      Octokit.rest_model(
        key: String,
        name: String,
        url: String?,

        spdx_id: String,
        html_url: String?,
        featured: Bool?,
        description: String?,
        implementation: String?,
        permissions: Array(String)?,
        conditions: Array(String)?,
        limitations: Array(String)?,
        body: String?
      )
    end
  end
end
