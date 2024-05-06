require "../helpers"

module Octokit
  module Models
    struct RepositoryMergeRequest
      Octokit.rest_model(
        base: String,
        head: String,
        commit_message: String
      )
    end
  end
end
