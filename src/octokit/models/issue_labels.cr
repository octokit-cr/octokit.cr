module Octokit
  module Models
    struct Label
      Octokit.rest_model(
        id: Int64,
        url: String,
        name: String,
        color: String,
        description: String?,
        default: Bool,
        node_id: String
      )
    end
  end
end
