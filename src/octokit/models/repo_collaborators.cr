module Octokit
  module Models
    struct ListCollaboratorOptions
      rest_model({
        affiliation: String,
      }.merge(ListOptions::FIELDS))
    end

    struct RepositoryPermissionLevel
      rest_model(
        permission: String,

        user: User
      )
    end

    struct RepositoryAddCollaboratorOptions
      rest_model(
        permission: String
      )
    end
  end
end
