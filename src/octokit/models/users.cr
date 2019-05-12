module Octokit
  module Models
    struct User
      rest_model(
        login: String,
        id: Int64,
        node_id: String,
        avatar_url: String,
        html_url: String,
        gravatar_id: String,
        name: String,
        company: String,
        blog: String,
        location: String,
        email: String,
        hireable: Bool,
        bio: String,
        public_repos: Int32,
        public_gists: Int32,
        followers: Int32,
        following: Int32,
        created_at: String,
        updated_at: String,
        suspended_at: String,
        type: String,
        site_admin: Bool,
        total_private_repos: Int32,
        owned_private_repos: Int32,
        private_gists: Int32,
        disk_usage: Int32,
        collaborators: Int32,
        two_factor_authentication: Bool,
        plan: Plan,

        url: String,
        events_url: String,
        following_url: String,
        followers_url: String,
        gists_url: String,
        organizations_url: String,
        received_events_url: String,
        repos_url: String,
        starred_url: String,
        subscriptions_url: String,

        text_matches: Array(TextMatch)?,

        permissions: Hash(String, Bool)
      )
    end

    struct HovercardOptions
      rest_model(
        subject_type: String,
        subject_id: String
      )
    end

    struct Hovercard
      rest_model(
        contexts: Array(UserContext)
      )
    end

    struct UserContext
      message: String,
      octicon: String
    end

    struct UserListOptions
      rest_model({
        since: Int64
      }).merge(ListOptions::FIELDS))
    end
  end
end
