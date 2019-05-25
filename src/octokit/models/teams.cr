module Octokit
  module Models
    class Team
      # Created as a class to prevent recursive struct
      Octokit.rest_model(
        id: Int64,
        node_id: String,
        name: String,
        description: String,
        url: String,
        slug: String,

        permission: String,

        privacy: String,

        members_count: Int32,
        repos_count: Int32,
        organization: Organization,
        members_url: String,
        repositories_url: String,
        parent: Team,

        ldap_dn: String?
      )
    end

    struct Invitation
      Octokit.rest_model(
        id: Int64,
        node_id: String,
        login: String,
        email: String,

        role: String,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        inviter: User,
        team_count: Int32,
        invitation_team_url: String
      )
    end

    struct NewTeam
      Octokit.rest_model(
        name: String,
        description: String,
        maintainers: Array(String),
        repo_names: Array(String),
        parent_team_id: Int64,

        permission: String,

        privacy: String,

        ldap_dn: String?
      )
    end

    struct TeamAddTeamRepoOptions
      Octokit.rest_model(
        permission: String
      )
    end

    struct TeamProjectOptions
      Octokit.rest_model(
        permission: String
      )
    end
  end
end
