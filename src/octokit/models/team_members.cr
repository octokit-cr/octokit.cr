module Octokit
  module Models
    struct TeamListTeamMembersOptions
      rest_model({
        role: String
    }.merge(ListOptions::FIELDS))
    end

    struct TeamAddTeamMembershipOptions
      rest_model(
        role: String
      )
    end
  end
end
