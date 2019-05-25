module Octokit
  module Models
    struct RepositoryInvitation
      Octokit.rest_model(
        id: Int64,
        repo: Repository,
        invitee: User,
        inviter: User,

        permissions: String,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        url: String,
        html_url: String
      )
    end
  end
end
