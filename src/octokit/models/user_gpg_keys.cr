module Octokit
  module Models
    struct GPGKey
      rest_model(
        id: Int64,
        primary_key_id: Int64,
        key_id: String,
        public_key: String,
        emails: Array(GPGEmail),
        subkeys: Array(GPGKey),
        can_sign: Bool,
        can_encrypt_coms: Bool,
        can_encrypt_storage: Bool,
        can_certify: Bool,
        created_at: String,
        expires_at: String
      )
    end

    struct GPGEmail
      rest_model(
        email: String,
        verified: Bool
      )
    end
  end
end
