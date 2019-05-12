require "halite"
require "./middleware/follow_redirects"
require "./response/raise_error"
require "./response/feed_parser"
require "./version"

module Octokit
  # Default configuration options for `Client`
  module Default
    # Default API endpoint
    API_ENDPOINT = "https://api.github.com"

    # Default User Agent header string
    USER_AGENT = "Octokit Crystal #{Octokit::VERSION}"

    # Default media type
    MEDIA_TYPE = "application/vnd.github.v3+json"

    # Default WEB endpoint
    WEB_ENDPOINT = "https://github.com"

    # Default Halite middleware stack
    MIDDLEWARE = [] of Halite::Feature

    # Configuration options
    macro options
      {% begin %}
        {
          {% for key in Octokit::Configurable::KEYS %}
            {{ key.id }}: Default.{{ key.id }},
          {% end %}
        }
      {% end %}
    end

    # Default access token from ENV
    def self.access_token
      ENV["OCTOKIT_ACCESS_TOKEN"]?
    end

    # Default API endpoint from ENV
    def self.api_endpoint
      ENV["OCTOKIT_API_ENDPOINT"]? || API_ENDPOINT
    end

    # Default pagination preference from ENV
    def self.auto_paginate
      !!ENV["OCTOKIT_AUTO_PAGINATE"]? || false
    end

    # Default bearer token from ENV
    def self.bearer_token
      ENV["OCTOKIT_BEARER_TOKEN"]?
    end

    # Default OAuth app key from ENV
    def self.client_id
      ENV["OCTOKIT_CLIENT_ID"]?
    end

    # Default OAuth app secret from ENV
    def self.client_secret
      ENV["OCTOKIT_SECRET"]?
    end

    # Default management console password from ENV
    def self.management_console_password
      ENV["OCTOKIT_ENTERPRISE_MANAGEMENT_CONSOLE_PASSWORD"]?
    end

    # Default management console endpoint from ENV
    def self.management_console_endpoint
      ENV["OCTOKIT_ENTERPRISE_MANAGEMENT_CONSOLE_ENDPOINT"]?
    end

    # Default options for `Halite::Options`
    def self.connection_options
      Halite::Options.new(
        headers: {
          accept:     default_media_type,
          user_agent: user_agent,
        }
      )
    end

    # Default media type from ENV or `MEDIA_TYPE`
    def self.default_media_type
      ENV["OCTOKIT_DEFAULT_MEDIA_TYPE"]? || MEDIA_TYPE
    end

    # Default GitHub username for Basic Auth from ENV
    def self.login
      ENV["OCTOKIT_LOGIN"]?
    end

    # Middleware stack for `Halite::Client`
    def self.middleware
      MIDDLEWARE
    end

    # Default GitHub password for Basic Auth from ENV
    def self.password
      ENV["OCTOKIT_PASSWORD"]?
    end

    # Default pagination page size from ENV
    def self.per_page
      page_size = ENV["OCTOKIT_PER_PAGE"]?
      page_size.to_i if page_size
    end

    # Default proxy server URI for Halite::Client from ENV
    # NOTE: Won't work until proxies are implemented by Halite
    def self.proxy
      ENV["OCTOKIT_PROXY"]?
    end

    # Default SSL verify mode from ENV
    def self.ssl_verify_mode
      # 0 is OpenSSL::SSL::NONE
      # 1 is OpenSSL::SSL::PEER
      # the standard default for SSL is PEER which requires a server certificate check on the client
      ENV.fetch("OCTOKIT_SSL_VERIFY_MODE", "1").to_i
    end

    # Default User-Agent header string from ENV or `USER_AGENT`
    def self.user_agent
      ENV["OCTOKIT_USER_AGENT"]? || USER_AGENT
    end

    # Default web endpoint from ENV or `WEB_ENDPOINT`
    def self.web_endpoint
      ENV["OCTOKIT_WEB_ENDPOINT"]? || WEB_ENDPOINT
    end
  end
end
