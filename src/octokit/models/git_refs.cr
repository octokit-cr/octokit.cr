module Octokit
  module Models
    struct Reference
      rest_model(
        ref: String,
        url: String,
        object: GitObject,
        node_id: String
      )
    end

    struct GitObject
      rest_model(
        type: String,
        sha: String,
        url: String
      )
    end

    struct CreateRefRequest
      rest_model(
        ref: String,
        sha: String
      )
    end

    struct UpdateRefRequest
      rest_model(
        sha: String,
        force: Bool
      )
    end
  end
end
