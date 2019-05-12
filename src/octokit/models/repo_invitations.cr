module Octokit
  module Models
    struct RepositoryInvitation
      rest_model(
        id: Int64,
        repo: Repository,
        invitee: User,
        inviter: User,

        permissions: String,
        created_at: String,
        url: String,
        html_url: String
      )
    end
  end
end
