module Octokit
  module Models
    struct Team
      rest_model(
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
      rest_model(
        id: Int64,
        node_id: String,
        login: String,
        email: String,

        role: String,
        created_at: String,
        inviter: User,
        team_count: Int32,
        invitation_team_url: String
      )
    end

    struct NewTeam
      rest_model(
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
      rest_model(
        permission: String
      )
    end

    struct TeamProjectOptions
      rest_model(
        permission: String
      )
    end
  end
end
