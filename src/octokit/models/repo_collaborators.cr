module Octokit
  module Models
    struct ListCollaboratorOptions
      Octokit.rest_model({
        affiliation: String,
        # }.merge(ListOptions::FIELDS))
      })
    end

    struct RepositoryPermissionLevel
      Octokit.rest_model(
        permission: String,
        user: User
      )
    end

    struct RepositoryAddCollaboratorOptions
      Octokit.rest_model(
        permission: String
      )
    end
  end
end
