module Octokit
  module Models
    struct Event
      rest_model(
        type: String,
        public: Bool,
        # TODO: Parse the payload
        raw_payload: {key: "payload", type: String},
        repo: Repository,
        actor: User,
        org: Orginization,
        created_at: String,
        id: String
      )
    end
  end
end
