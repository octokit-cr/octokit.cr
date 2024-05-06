require "../models/orgs"
require "../models/users"

module Octokit
  class Client
    # Methods for the Organizations API
    #
    # **See Also:**
    # - [https://developer.github.com/v3/orgs/](https://developer.github.com/v3/orgs/)
    module Organizations
      # :nodoc:
      alias Organization = Models::Organization
      alias OrganizationListItem = Models::OrganizationListItem
      alias User = Models::User

      # List all GitHub organizations
      #
      # This provides a list of every organization, in the order that they were created
      # on GitHub.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/orgs/#list-organizations](https://developer.github.com/v3/orgs/#list-organizations)
      def organizations
        # paginate Organization, "organizations", **options
        res = paginate "organizations"
        OrganizationListItem.from_json(res)
      end

      # Get a single organization
      #
      # **See Also:**
      # - [https://developer.github.com/v3/orgs#get-an-organization](https://developer.github.com/v3/orgs#get-an-organization)
      def organization(organization)
        res = get Organization.path(organization)
        Organization.from_json(res)
      end

      # List organizations for authenticated user
      #
      # **See Also:**
      # - [https://developer.github.com/v3/orgs#list-organizations-for-the-authenticated-user](https://developer.github.com/v3/orgs#list-organizations-for-the-authenticated-user)
      def organizations_for_authenticated_user
        paginate OrganizationListItem, "user/orgs"
      end

      # List organizations for a user
      #
      # **See Also:**
      # - [https://developer.github.com/v3/orgs#list-organizations-for-a-user](https://developer.github.com/v3/orgs#list-organizations-for-a-user)
      def organizations_for_user(user)
        paginate OrganizationListItem, "#{User.path user}/orgs"
      end
    end
  end
end
