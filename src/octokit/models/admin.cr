module Octokit
  module Models
    struct TeamLDAPMapping
      Octokit.rest_model(
        id: Int64,
        ldap_dn: String,
        url: String,
        name: String,
        slug: String,
        description: String,
        privacy: String,
        permission: String,

        members_url: String,
        repositories_url: String
      )
    end

    struct UserLDAPMapping
      Octokit.rest_model(
        id: Int64,
        ldap_dn: String,
        login: String,
        avatar_url: String,
        gravatar_id: String,
        type: String,
        site_admin: String,

        url: String,
        events_url: String,
        following_url: String,
        followers_url: String,
        gists_url: String,
        organizations_url: String,
        received_events_url: String,
        repos_url: String,
        starred_url: String,
        subscriptions_url: String
      )
    end
  end
end
