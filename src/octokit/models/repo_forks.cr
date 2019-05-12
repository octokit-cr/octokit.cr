module Octokit
  module Models
    struct RepositoryListForksOptions
      rest_model({
        sort: String
      }.merge(ListOptions::FIELDS))
    end

    struct RepositoryCreateForkOptions
      rest_model(
        organization: String
      )
    end
  end
end
