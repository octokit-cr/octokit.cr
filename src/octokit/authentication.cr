module Octokit
  # Authentication methods for `Octokit::Client`
  module Authentication
    # Indicates if the client was supplied Basic Auth
    # username and password
    #
    # **See Also:**
    # - [https://developer.github.com/v3/#authentication](https://developer.github.com/v3/#authentication)
    def basic_authenticated?
      !!(@login && @password)
    end

    # Indicates if the client was supplied an OAuth
    # access token
    #
    # **See Also:**
    # - [https://developer.github.com/v3/#authentication](https://developer.github.com/v3/#authentication)
    def token_authenticated?
      !!@access_token
    end

    # Indicates if the client was supplied a bearer token
    #
    # **See Also:**
    # - [https://developer.github.com/early-access/integrations/authentication/#as-an-integration](https://developer.github.com/early-access/integrations/authentication/#as-an-integration)
    def bearer_authenticated?
      !!@bearer_token
    end

    # Indicates if the client was supplied an OAuth
    # access token or Basic Auth username and password
    #
    # **See Also:**
    # - [https://developer.github.com/v3/#authentication](https://developer.github.com/v3/#authentication)
    def user_authenticated?
      basic_authenticated? || token_authenticated?
    end

    # Indicates if the client has OAuth Application
    # client_id and secret credentials to make anonymous
    # requests at a higher rate limit
    #
    # **See Also:**
    # - [https://developer.github.com/v3/#unauthenticated-rate-limited-requests](https://developer.github.com/v3/#unauthenticated-rate-limited-requests)
    def application_authenticated?
      !!application_authentication
    end

    private def application_authentication
      if @client_id && @client_secret
        {"client_id" => @client_id, "client_secret" => @client_secret}
      end
    end

    # def login_from_netrc
    #   return unless netrc?

    #   require 'netrc'
    #   info = Netrc.read netrc_file
    #   netrc_host = URI.parse(api_endpoint).host
    #   creds = info[netrc_host]
    #   if creds.nil?
    #     # creds will be nil if there is no netrc for this end point
    #     octokit_warn "Error loading credentials from netrc file for #{api_endpoint}"
    #   else
    #     creds = creds.to_a
    #     self.login = creds.shift
    #     self.password = creds.shift
    #   end
    # rescue LoadError
    #   octokit_warn "Please install netrc gem for .netrc support"
    # end
  end
end
