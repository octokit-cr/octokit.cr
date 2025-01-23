# This class provides a wrapper around the Octokit client for GitHub App authentication.
# It handles token generation and refreshing, and delegates method calls to the Octokit client.
# Helpful: https://github.com/octokit/handbook?tab=readme-ov-file#github-app-authentication-json-web-token
#
# Usage (examples):
# github = GitHub.new
# github.get "/meta"
# github.get "/repos/<org>/<repo>"
# github.user "grantbirki"

# Why? In some cases, you may not want to have a static long lived token like a GitHub PAT when authenticating...
# Most importantly, this class will handle automatic token refreshing for you out-of-the-box. Simply provide the...
# correct environment variables, call `GitHub.new`, and then use the returned object as you would an Octokit client.

require "octokit"
require "jwt"
require "openssl"
require "json"

class GitHub
  TOKEN_EXPIRATION_TIME = 2700 # 45 minutes
  JWT_EXPIRATION_TIME   =  600 # 10 minutes

  @client : Octokit::Client
  @app_id : Int32
  @installation_id : Int32
  @app_key : String

  def initialize
    @app_id = fetch_env_var("GITHUB_APP_ID").to_i
    @installation_id = fetch_env_var("GITHUB_APP_INSTALLATION_ID").to_i
    @app_key = fetch_env_var("GITHUB_APP_PRIVATE_KEY").gsub(/\\+n/, "\n")
    @token_refresh_time = Time.unix(0)
    @client = create_client
  end

  private def fetch_env_var(key : String) : String
    ENV[key]? || raise "environment variable #{key} is not set"
  end

  private def client
    if @client.nil? || token_expired?
      @client = create_client
    end
    @client
  end

  private def jwt_token : String
    private_key = OpenSSL::PKey::RSA.new(@app_key)
    payload = {
      "iat" => Time.utc.to_unix - 60,
      "exp" => Time.utc.to_unix + JWT_EXPIRATION_TIME,
      "iss" => @app_id,
    }
    JWT.encode(payload, private_key.to_pem, JWT::Algorithm::RS256)
  end

  private def create_client
    tmp_client = Octokit.client(bearer_token: jwt_token)
    response = tmp_client.create_app_installation_access_token(@installation_id, **{headers: {authorization: "Bearer #{tmp_client.bearer_token}"}})
    access_token = JSON.parse(response)["token"].to_s

    client = Octokit.client(access_token: access_token)
    client.auto_paginate = true
    client.per_page = 100
    @token_refresh_time = Time.utc
    client
  end

  private def token_expired? : Bool
    Time.utc.to_unix - @token_refresh_time.to_unix > TOKEN_EXPIRATION_TIME
  end

  macro method_missing(call)
    {% if call.block %}
      client.{{call.name}}({{*call.args}}) do |{{call.block.args}}|
        {{call.block.body}}
      end
    {% else %}
      client.{{call.name}}({{*call.args}})
    {% end %}
  end

  def respond_to_missing?(method_name : Symbol, include_private : Bool = false) : Bool
    client.respond_to?(method_name) || super
  end
end

# github = GitHub.new
# github.add_comment("<owner>/<repo>", <number>, "some comment here")
