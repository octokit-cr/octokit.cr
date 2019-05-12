module Octokit
  module Models
    struct Tree
      Octokit.rest_model(
        sha: String,
        entries: Array(TreeEntry),

        truncated: Bool
      )
    end

    struct TreeEntry
      Octokit.rest_model(
        sha: String,
        path: String,
        mode: String,
        type: String,
        size: Int32,
        content: String,
        url: String
      )
    end
  end
end
