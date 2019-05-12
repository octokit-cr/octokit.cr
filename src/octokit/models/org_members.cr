module Octokit
  module Models
    struct Membership
      rest_model(
        url: String,

        state: String,

        role: String,

        organization_url: String,

        organization: Organization,

        user: user
      )
    end

    struct ListMembershipOptions
      rest_model({
        public_only: Bool,

        filter: String,

        role: String,
      }.merge(ListOptions::FIELDS))
    end

    struct ListOrgMembershipOptions
      rest_model({
        state: String,
      }.merge(ListOptions::FIELDS))
    end

    struct CreateOrgInvitationOptions
      rest_model(
        invitee_id: Int64,

        email: String,

        role: String,
        team_id: Int64
      )
    end
  end
end
