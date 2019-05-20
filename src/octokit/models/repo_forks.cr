module Octokit
  module Models
    struct RepositoryListForksOptions
      Octokit.rest_model({
        sort: String,
        # }.merge(ListOptions::FIELDS))
      })
    end

    struct RepositoryCreateForkOptions
      Octokit.rest_model(
        organization: String
      )
    end
  end
end
