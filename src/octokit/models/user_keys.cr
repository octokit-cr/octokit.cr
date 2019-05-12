module Octokit
  module Models
    struct Key
      Octokit.rest_model(
        id: Int64,
        key: String,
        url: String,
        title: String,
        read_only: Bool
      )
    end
  end
end
