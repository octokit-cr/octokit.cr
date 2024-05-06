require "../core_ext/time"
require "../helpers"

module Octokit
  module Models
    struct Authorization
      Octokit.rest_model(
        id: Int64,
        url: String,
        scopes: Array(String),
        token: String,
        token_has_eight: String,
        hashed_token: String,
        app: AuthorizationApp,
        note: String,
        note_url: String,
        updated_at: {type: Time, converter: Time::ISO8601Converter},
        created_at: {type: Time, converter: Time::ISO8601Converter},
        fingerprint: String
      )
    end

    struct AuthorizationApp
      Octokit.rest_model(
        url: String,
        name: String,
        client_id: String
      )
    end

    struct Grant
      Octokit.rest_model(
        id: Int64,
        url: String,
        app: AuthorizationApp,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        updated_at: {type: Time, converter: Time::ISO8601Converter},
        scopes: Array(String)
      )
    end

    struct AuthorizationRequest
      Octokit.rest_model(
        scopes: Array(String),
        note: String,
        note_url: String,
        client_id: String,
        client_secret: String,
        fingerprint: String
      )
    end

    struct AuthorizationUpdateRequest
      Octokit.rest_model(
        scopes: Array(String),
        add_scopes: Array(String),
        remove_scopes: Array(String),
        note: String,
        note_url: String,
        fingerprint: String
      )
    end
  end
end
