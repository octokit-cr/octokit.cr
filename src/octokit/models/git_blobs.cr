module Octokit
  module Models
    struct Blob
      Octokit.rest_model(
        content: String,
        encoding: String,
        sha: String,
        size: Int32,
        url: String,
        node_id: String
      )
    end
  end
end
