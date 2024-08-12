require "./models/*"
require "./connection"
require "./warnable"
require "./arguments"
require "./configurable"
require "./authentication"
require "./rate_limit"
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
  # User client for interacting with the GitHub API.
  #
  # The `Client` class is your main entrypoint into the GitHub user API. If
  # you want to access the enterprise admin or enterprise management APIs,
  # see `EnterpriseAdminClient` and `EnterpriseManagementClient`
  # respectively.
  #
  # **Configuration:**
  # Configuration options for `Client` are stored in `Configurable` and include:
  # - access_token        : `String`
  # - auto_paginate       : `Bool`
  # - bearer_token        : `String`
  # - client_id           : `String`
  # - client_secret       : `String`
  # - default_media_type  : `String`
  # - connection_options  : `Halite::Options`
  # - middleware          : `Array(Halite::Feature)`
  # - per_page            : `Int32`
  # - proxy               : `String`
  # - ssl_verify_mode     : `Int32`
  # - user_agent          : `String`
  #
  # The following items are setters only:
  # - api_endpoint        : `String`
  # - login               : `String`
  # - password            : `String`
  # - web_endpoint        : `String`
  #
  # Defaults for these are stored in `Default`. Most can be set using
  # environment variables.
  #
  # **Examples:**
  #
  # With standard auth:
  # ```
  # @client = Octokit::Client.new("monalisa", "PASSWORD")
  # ```
  #
  # With access token:
  # ```
  # @client = Octokit::Client.new("monalisa", access_token: "ACCESS_TOKEN")
  # ```
  #
  # With bearer token:
  # ```
  # @client = Octokit::Client.new("monalisa", bearer_token: "BEARER_TOKEN")
  # ```
  class Client
    include Octokit::Authentication
    include Octokit::Configurable
    include Octokit::Connection
    include Octokit::Preview
    include Octokit::Warnable
    include Octokit::Client::Authorizations
    include Octokit::Client::Issues
    include Octokit::Client::Markdown
    include Octokit::Client::PubSubHubbub
    include Octokit::Client::PullRequests
    include Octokit::Client::Users
    include Octokit::Client::RateLimit
    include Octokit::Client::Repositories
    include Octokit::Client::Organizations
    include Octokit::Client::Releases
    include Octokit::Client::Search
    include Octokit::Client::Statuses
    include Octokit::Client::Say
    include Octokit::Client::Deployments

    CONVENIENCE_HEADERS = Set{"accept", "content_type"}

    # Create a new Client instance.
    #
    # **Example:**
    # ```
    # cli = Octokit::Client.new("monalisa", "MY_PASSWORD")
    # pp cli.user # Show information about the logged in user
    # ```
    def initialize(
      @login : String? = nil,
      @password : String? = nil,
      @access_token : String? = nil,
      @bearer_token : String? = nil,
      @client_id : String? = nil,
      @client_secret : String? = nil
    )
    end

    # Create a new Client instance yielding a block.
    #
    # **Example:**
    # ```
    # Octokit::Client.new("monalisa", "MY_PASSWORD") do |cli|
    #   pp cli.user # Show information about the logged in user
    # end
    # ```
    def initialize(
      @login : String? = nil,
      @password : String? = nil,
      @access_token : String? = nil,
      @bearer_token : String? = nil,
      @client_id : String? = nil,
      @client_secret : String? = nil,
      &
    )
      yield self
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

    def as_app(key = @client_id, secret = @client_secret, &)
      if !key || !secret
        raise Error::ApplicationCredentialsRequired.new("client_id and client_secret required")
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

    def ensure_basic_authenticated!
      unless !!@login && !!@password
        raise "Client not Basic authenticated"
      end
    end

    def ensure_token_authenticated!
      unless !!@access_token
        raise "Client not Token authenticated"
      end
    end

    def client_without_redirects(options = {} of String => String)
      raise "unimplemented method"
    end
  end
end
