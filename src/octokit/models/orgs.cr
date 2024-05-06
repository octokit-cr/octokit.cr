require "../core_ext/time"
require "../helpers"

module Octokit
  module Models
    struct Organization
      def path
        Organization.path(self)
      end

      def self.path(org)
        "orgs/#{org}"
      end

      Octokit.rest_model(
        login: String,
        id: Int64,
        node_id: String,
        avatar_url: String,
        html_url: String,
        name: String,
        company: String,
        blog: String,
        location: String,
        email: String,
        description: String,
        public_repos: Int32,
        public_gists: Int32,
        followers: Int32,
        following: Int32,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        updated_at: {type: Time, converter: Time::ISO8601Converter},
        total_private_repos: Int32,
        owned_private_repos: Int32,
        private_gists: Int32,
        disk_usage: Int32,
        collaborators: Int32,
        billing_email: String,
        type: String,
        plan: Plan,
        two_factor_requirement_enabled: Bool,

        default_repo_permission: String,

        default_repo_settings: String,

        members_can_create_repos: Bool,

        url: String,
        events_url: String,
        hooks_url: String,
        issues_url: String,
        members_url: String,
        public_members_url: String,
        repos_url: String
      )
    end

    struct OrganizationListItem
      Octokit.rest_model(
        login: String,
        id: Int32,
        node_id: String,
        url: String,
        repos_url: String,
        events_url: String,
        hooks_url: String,
        issues_url: String,
        members_url: String,
        public_members_url: String,
        avatar_url: String,
        description: String | Nil
      )
    end

    struct Plan
      Octokit.rest_model(
        name: String,
        space: Int32,
        collaborators: Int32,
        private_repos: Int32
      )
    end

    struct OrganizationsListOptions
      Octokit.rest_model({
        since: Int64,
        # }.merge(ListOptions::FIELDS))
      })
    end
  end
end
