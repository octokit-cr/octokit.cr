module Octokit
  module Models
    struct Authorizations
      rest_model(
        id: Int64,
        url: String,
        scopes: Array(Scope),
        token: String,
        token_has_eight: String,
        hashed_token: String,
        app: AuthorizationApp,
        note: String,
        note_url: String,
        updated_at: Timestamp,
        created_at: Timestamp,
        fingerprint: String
      )
    end

    struct Grant
      rest_model(
        id: Int64,
        url: String,
        app: AuthorizationApp,
        created_at: Timestamp,
        updated_at: Timestamp,
        scopes: Array(String)
      )
    end

    struct AuthorizationRequest
      rest_model(
        scopes: Array(Scope),
        note: String,
        note_url: String,
        client_id: String,
        client_secret: String,
        fingerprint: String
      )
    end

    struct AuthorizationUpdateRequest
      rest_model(
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
