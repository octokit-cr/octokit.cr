require "../src/octokit"
require "jwt"
require "openssl"
require "json"

# A helper function for encoding JWTs
# :param app_id [String] the client ID of the GitHub App
# :param private_key [String] the private key for the GitHub App
# :return [String] the encoded JWT
def encode(app_id : String, private_key : String) : String
  rsa_key = OpenSSL::PKey::RSA.new(private_key).to_pem


  payload = {
    "iss" => app_id,
    "exp" => Time.utc.to_unix + (10 * 60), # 10 minutes from now
    "iat" => Time.utc.to_unix - 60,        # to account for clock drift
  }

  JWT.encode(payload, rsa_key, JWT::Algorithm::RS256)
end

jwt = encode(ENV.fetch("GITHUB_APP_ID"), ENV.fetch("GITHUB_APP_PRIVATE_KEY").gsub(/\\+n/, "\n"))

# Create a new Octokit Client using the jwt
github = Octokit.client(bearer_token: jwt)
github.auto_paginate = true
github.per_page = 100

options = {headers: {authorization: "Bearer #{github.bearer_token}"}}

installation_id = ENV.fetch("GITHUB_APP_INSTALLATION_ID").to_i

response = JSON.parse(github.create_app_installation_access_token(installation_id, **options))

client = Octokit.client(access_token: response["token"].to_s)
client.auto_paginate = true
client.per_page = 100

# Use client as you would any other Octokit client here...
