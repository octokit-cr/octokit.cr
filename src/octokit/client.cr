require "./error"
require "./connection"
require "./authentication"

module Octokit
  class Client
    include Octokit::Authentication
    include Octokit::Connection

    getter authenticated : Bool = false

    CONVENIENCE_HEADERS = Set{"accept", "content_type"}

    def initialize(
      @login : String,
      @password : String,
      @access_token : String? = nil,
      @bearer_token : String? = nil,
      @client_id : String? = nil,
      @client_secret : String? = nil
    )
    end

    # Text representation of the client, masking tokens and passwords
    def inspect
      inspected = super

      # mask password
      inspected = inspected.gsub @password.to_s, "*******" if @password
      # inspected = inspected.gsub @management_console_password, "*******" if @management_console_password
      inspected = inspected.gsub @bearer_token.to_s, "********" if @bearer_token

      # Only show last 4 of token, secret
      inspected = inspected.gsub @access_token.to_s, "#{"*"*36}#{@access_token.to_s[36..-1]}" if @access_token
      inspected = inspected.gsub @client_secret.to_s, "#{"*"*36}#{@client_secret.to_s[36..-1]}" if @client_secret

      inspected
    end

    def as_app(key = @client_id, secret = @client_secret, &block)
      if !key || !secret
        raise ApplicationCredentialsRequired.new("client_id and client_secret required")
      end

      app_client = self.dup
      app_client.client_id = app_client.client_secret = nil
      app_client.login = key
      app_client.password = secret

      yield app_client
    end

    # Set username for authentication
    def login=(value : String)
      reset_agent
      @login = value
    end

    # Set password for authentication
    def password=(value : String)
      reset_agent
      @password = value
    end

    # Set OAuth access token for authentication
    def access_token=(value : String)
      reset_agent
      @access_token = value
    end

    # Set Bearer Token for authentication
    def bearer_token=(value : String)
      reset_agent
      @bearer_token = value
    end

    # Set OAuth app client_id
    def client_id=(value : String)
      reset_agent
      @client_id = value
    end

    # Set OAuth app client_secret
    def client_secret=(value : String)
      reset_agent
      @client_secret = value
    end

    def client_without_redirects(options = {} of String => String)
      raise "unimplemented method"
    end
  end
end
