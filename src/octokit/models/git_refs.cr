module Octokit
  module Models
    struct Reference
      Octokit.rest_model(
        ref: String,
        url: String,
        object: GitObject,
        node_id: String
      )
    end

    struct GitObject
      Octokit.rest_model(
        type: String,
        sha: String,
        url: String
      )
    end

    struct CreateRefRequest
      Octokit.rest_model(
        ref: String,
        sha: String
      )
    end

    struct UpdateRefRequest
      Octokit.rest_model(
        sha: String,
        force: Bool
      )
    end
  end
end
