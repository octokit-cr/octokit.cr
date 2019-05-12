require "./models/*"
require "./connection"
require "./warnable"
require "./arguments"
require "./repo_arguments"
require "./configurable"
require "./authentication"
require "./gist"
require "./rate_limit"
require "./repository"
require "./user"
require "./organization"
require "./preview"
require "./client/apps"
require "./client/authorizations"
require "./client/checks"
require "./client/commits"
require "./client/commit_comments"
require "./client/community_profile"
require "./client/contents"
require "./client/downloads"
require "./client/deployments"
require "./client/emojis"
require "./client/events"
require "./client/feeds"
require "./client/gists"
require "./client/gitignore"
require "./client/hooks"
require "./client/issues"
require "./client/labels"
require "./client/legacy_search"
require "./client/licenses"
require "./client/meta"
require "./client/markdown"
require "./client/marketplace"
require "./client/milestones"
require "./client/notifications"
require "./client/objects"
require "./client/organizations"
require "./client/pages"
require "./client/projects"
require "./client/pub_sub_hubbub"
require "./client/pull_requests"
require "./client/rate_limit"
require "./client/reactions"
require "./client/refs"
require "./client/releases"
require "./client/repositories"
require "./client/repository_invitations"
require "./client/reviews"
require "./client/say"
require "./client/search"
require "./client/service_status"
require "./client/source_import"
require "./client/stats"
require "./client/statuses"
require "./client/traffic"
require "./client/users"

module Octokit
  class Client
    include Octokit::Authentication
    include Octokit::Configurable
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
