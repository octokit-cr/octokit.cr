module Octokit
  module Models
    struct RepositoryContent
      Octokit.rest_model(
        type: String,

        target: String,
        encoding: String,
        size: String,
        name: String,
        path: String,

        content: String,
        sha: String,
        url: String,
        git_url: String,
        html_url: String,
        download_url: String
      )
    end

    struct RepositoryContentResponse
      Octokit.rest_model(
        content: RepositoryContent,
        commit: Commit
      )
    end

    struct RepositoryContentFileOptions
      Octokit.rest_model(
        message: String,
        content: Array(UInt8),
        sha: String,
        branch: String,
        author: CommitAuthor,
        commiter: CommitAuthor
      )
    end

    struct RepositoryContentGetOptions
      Octokit.rest_model(
        ref: String
      )
    end
  end
end
