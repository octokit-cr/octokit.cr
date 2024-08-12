require "halite"
require "./middleware/follow_redirects"
require "./response/raise_error"
require "./response/feed_parser"
require "./version"

module Octokit
  # Default configuration options for `Client`
  module Default
    extend self

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

    # :nodoc:
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
    def access_token : String?
      ENV["OCTOKIT_ACCESS_TOKEN"]?
    end

    # Default API endpoint from ENV
    def api_endpoint
      ENV["OCTOKIT_API_ENDPOINT"]? || API_ENDPOINT
    end

    # Default pagination preference from ENV
    def auto_paginate
      !!ENV["OCTOKIT_AUTO_PAGINATE"]? || false
    end

    # Default bearer token from ENV
    def bearer_token
      ENV["OCTOKIT_BEARER_TOKEN"]?
    end

    # Default OAuth app key from ENV
    def client_id
      ENV["OCTOKIT_CLIENT_ID"]?
    end

    # Default OAuth app secret from ENV
    def client_secret
      ENV["OCTOKIT_SECRET"]?
    end

    # Default management console password from ENV
    def management_console_password
      ENV["OCTOKIT_ENTERPRISE_MANAGEMENT_CONSOLE_PASSWORD"]?
    end

    # Default management console endpoint from ENV
    def management_console_endpoint
      ENV["OCTOKIT_ENTERPRISE_MANAGEMENT_CONSOLE_ENDPOINT"]?
    end

    # Default options for `Halite::Options`
    def connection_options : Halite::Options
      Halite::Options.new(
        headers: {
          accept:     default_media_type,
          user_agent: user_agent,
        })
    end

    # Default media type from ENV or `MEDIA_TYPE`
    def default_media_type
      ENV["OCTOKIT_DEFAULT_MEDIA_TYPE"]? || MEDIA_TYPE
    end

    # Default GitHub username for Basic Auth from ENV
    def login : String?
      ENV["OCTOKIT_LOGIN"]?
    end

    # Middleware stack for `Halite::Client`
    def middleware
      MIDDLEWARE
    end

    # Default GitHub password for Basic Auth from ENV
    def password : String?
      ENV["OCTOKIT_PASSWORD"]?
    end

    # Default pagination page size from ENV
    def per_page : Int32?
      page_size = ENV["OCTOKIT_PER_PAGE"]?
      page_size.to_i if page_size
    end

    # Default proxy server URI for Halite::Client from ENV
    # NOTE: Won't work until proxies are implemented by Halite
    def proxy
      ENV["OCTOKIT_PROXY"]?
    end

    # Default SSL verify mode from ENV
    def ssl_verify_mode : Int32
      # 0 is OpenSSL::SSL::NONE
      # 1 is OpenSSL::SSL::PEER
      # the standard default for SSL is PEER which requires a server certificate check on the client
      ENV.fetch("OCTOKIT_SSL_VERIFY_MODE", "1").to_i
    end

    # Default User-Agent header string from ENV or `USER_AGENT`
    def user_agent : String
      ENV["OCTOKIT_USER_AGENT"]? || USER_AGENT
    end

    # Default web endpoint from ENV or `WEB_ENDPOINT`
    def web_endpoint : String
      ENV["OCTOKIT_WEB_ENDPOINT"]? || WEB_ENDPOINT
    end

    # Default logger
    def logger
      log_level = ENV["OCTOKIT_LOG_LEVEL"]?.to_s.upcase || "INFO".to_s.upcase
      Log.setup(log_level)
      ::Log.for(self)
    end
  end
end
