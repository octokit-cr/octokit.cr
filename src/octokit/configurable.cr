require "log"
require "./default"

module Octokit
  # Provides configuration options for `Client`.
  module Configurable
    # :nodoc:
    KEYS = [
      "access_token",
      "api_endpoint",
      "auto_paginate",
      "bearer_token",
      "client_id",
      "client_secret",
      "connection_options",
      "default_media_type",
      "login",
      "management_console_endpoint",
      "management_console_password",
      "middleware",
      "per_page",
      "password",
      "proxy",
      "ssl_verify_mode",
      "user_agent",
      "web_endpoint",
      "logger",
    ]

    @access_token : String? = nil

    # Get access token for authentication.
    def access_token
      @access_token
    end

    # Set access token for authentication.
    def access_token=(token)
      @access_token = token
    end

    @auto_paginate : Bool = Default.auto_paginate

    # Do we want to auto paginate.
    def auto_paginate
      @auto_paginate
    end

    # Set if we want to auto paginate.
    def auto_paginate=(val)
      @auto_paginate = val
    end

    @bearer_token : String? = nil

    # Get the bearer token.
    def bearer_token
      @bearer_token
    end

    # Set the bearer token.
    def bearer_token=(token)
      @bearer_token = token
    end

    @client_id : String? = nil

    # Get the Client ID.
    def client_id
      @client_id
    end

    # Set the Client ID.
    def client_id=(val)
      @client_id = val
    end

    @client_secret : String? = nil

    # Get the Client Secret.
    def client_secret
      @client_secret
    end

    # Set the Client secret.
    def client_secret=(val)
      @client_secret = val
    end

    # The default type to use for accept headers.
    @default_media_type : String = Default.default_media_type

    # Get the default media type for headers.
    def default_media_type
      @default_media_type
    end

    # Set the default media type for headers.
    def default_media_type=(val)
      @default_media_type = val
    end

    # `Halite::Options` to be used for all connections.
    @connection_options : Halite::Options = Default.connection_options

    # Get the default connection options passed to Halite.
    def connection_options
      @connection_options
    end

    # Set the default connection options passed to Halite.
    def connection_options=(val)
      @connection_options = val
    end

    # Array of `Halite::Feature` to be used as middleware for requests.
    @middleware : Array(Halite::Feature) = Default.middleware

    # Get the middleware stack for Halite.
    def middleware
      @middleware
    end

    # Set the middleware stack for Halite.
    def middleware=(val)
      @middleware = val
    end

    # Add middleware to the middleware stack.
    def add_middleware(middleware : Halite::Feature)
      @middleware << middleware
    end

    @per_page : Int32?

    # Get the maximum results returned per page for paginated endpoints.
    def per_page
      @per_page
    end

    # Set the maximum results returned per page for paginated endpoints.
    def per_page=(val)
      @per_page = val
    end

    # Logger. Must be compatible with Crystal logger.
    @logger : Log = Default.logger

    # Get the configured logger instance.
    def logger
      @logger
    end

    # Set a configured logger instance.
    def logger=(val)
      @logger = val
    end

    @proxy : String? = nil

    # Get the proxy to use when connecting.
    # **Note:** Crystal's `HTTP::Client` and by extension `Halite` do not yet
    # support proxy's. Therefore this option does nothing for now.
    def proxy
      @proxy
    end

    # Set the proxy to use when connecting.
    # **Note:** Crystal's `HTTP::Client` and by extension `Halite` do not yet
    # support proxy's. Therefore this option does nothing for now.
    def proxy=(val)
      @proxy = val
    end

    @ssl_verify_mode : Int32 = Default.ssl_verify_mode

    # Get the `OpenSSL` verify mode to use for SSL connections.
    # 0 is OpenSSL::SSL::NONE
    # 1 is OpenSSL::SSL::PEER
    def ssl_verify_mode
      @ssl_verify_mode
    end

    # Set the `OpenSSL` verify mode to use for SSL connections.
    # 0 is OpenSSL::SSL::NONE
    # 1 is OpenSSL::SSL::PEER
    def ssl_verify_mode=(mode)
      @ssl_verify_mode = mode
    end

    @user_agent : String = Default.user_agent

    # Get the User Agent header to be passed to all requests.
    def user_agent
      @user_agent
    end

    # Set the User Agent header to be passed to all requests.
    def user_agent=(val)
      @user_agent = val
    end

    @web_endpoint : String = Default.web_endpoint

    # Get the web endpoint.
    def web_endpoint
      @web_endpoint
    end

    # Set the web endpoint.
    def web_endpoint=(val)
      @web_endpoint = val
    end

    @api_endpoint : String = Default.api_endpoint

    # Get the api endpoint.
    def api_endpoint
      @api_endpoint
    end

    # Set the api endpoint.
    def api_endpoint=(val)
      @api_endpoint = val
    end

    @password : String? = nil

    # Set the user password.
    def password=(val)
      @password = val
    end

    @login : String? = nil

    # Set the user login.
    def login=(val)
      @login = val
    end

    @management_console_endpoint : String? = nil

    # Set the management console endpoint.
    def management_console_endpoint=(val)
      @management_console_endpoint = val
    end

    # Get the management console endpoint.
    def management_console_endpoint
      @management_console_endpoint
    end

    @management_console_password : String? = nil

    # Set the management console password.
    def management_console_endpoint=(val)
      @management_console_endpoint = val
    end

    # Yield a block allowing configuration of options.
    #
    # **Example:**
    # ```
    # @client.configure do
    #   auto_paginate = true
    # end
    # ```
    def configure(&)
      yield
    end

    def reset!
      do_reset!
    end

    # Resets the configuration options to their defaults definied in `Default`.
    private macro do_reset!
      {% begin %}
        {% for key in KEYS %}
          @{{ key.id }} = Octokit::Default.options[{{ key.id.stringify }}]
        {% end %}
      {% end %}
    end

    # API endpoint for `Client`.
    def api_endpoint
      File.join(@api_endpoint, "")
    end

    # API endpoint for `EnterpriseManagementConsoleClient`
    def management_console_endpoint
      return if @management_console_endpoint.nil?
      File.join(@management_console_endpoint.not_nil!, "")
    end

    # Base URL for generated web URLs
    def web_endpoint
      File.join(@web_endpoint, "")
    end

    # The username of the authenticated user
    def login
      @login ||= begin
        user.login if token_authenticated?
      rescue e : Exception
      end
    end

    private macro options
      {% begin %}
        [
        {% for key in KEYS %}
          [{{key.id.stringify}}, @{{key.id}}],
        {% end %}
        ].to_h
      {% end %}
    end
  end
end
