module Octokit
  module Models
    struct ListOutsideCollaboratorsOptions
      rest_model({
        filter: String
      }.merge(ListOptions::FIELDS))
    end
  end
end
