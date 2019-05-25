module Octokit
  module Models
    struct Event
      Octokit.rest_model(
        type: String,
        public: Bool,
        # TODO: Parse the payload
        raw_payload: {key: "payload", type: String},
        repo: Repository,
        actor: User,
        org: Organization,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        id: String
      )
    end
  end
end
