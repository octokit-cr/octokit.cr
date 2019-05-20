module Octokit
  module Models
    struct TeamListTeamMembersOptions
      Octokit.rest_model({
        role: String,
        # }.merge(ListOptions::FIELDS))
      })
    end

    struct TeamAddTeamMembershipOptions
      Octokit.rest_model(
        role: String
      )
    end
  end
end
