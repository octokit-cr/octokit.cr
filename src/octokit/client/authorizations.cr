require "../models/authorizations"

module Octokit
  class Client
    # Methods for the Authorizations API
    #
    # **See Api:**
    # - [https://developer.github.com/v3/oauth_authorizations/#oauth-authorizations-api](https://developer.github.com/v3/oauth_authorizations/#oauth-authorizations-api)
    module Authorizations
      # :nodoc:
      alias Authorization = Models::Authorization

      # List the authenticated user's authorizations.
      #
      # API for users to manage their own tokens.
      # You can only access your own tokens, and only through
      # Basic Authentication.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/oauth_authorizations/#list-your-authorizations](https://developer.github.com/v3/oauth_authorizations/#list-your-authorizations)
      #
      # **Example:**
      # ```
      # @client = Octokit.client("monalisa", "PASSWORD")
      # @client.authorizations
      # ```
      def authorizations(**options) : Connection::Paginator(Authorization)
        paginate Authorization, "authorizations", options: {json: options}
      end

      # Get a single authorization for the authenticated user.
      #
      # You can only access your own tokens, and only through
      # Basic Authentication.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/oauth_authorizations/#get-a-single-authorization](https://developer.github.com/v3/oauth_authorizations/#get-a-single-authorization)
      #
      # **Example:**
      # ```
      # @client = Octokit.client("monalisa", "PASSWORD")
      # @client.authorization(999999)
      # ```
      def authorizations(number : Int32) : Authorization
        res = get "authorizations/#{number}"
        Authorization.from_json(res)
      end

      # Create an authorization for the authenticated user.
      #
      # You can only access your own tokens, and only through
      # Basic Authentication.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/oauth/#scopes](https://developer.github.com/v3/oauth/#scopes)
      # - [https://developer.github.com/v3/oauth_authorizations/#create-a-new-authorization](https://developer.github.com/v3/oauth_authorizations/#create-a-new-authorization)
      # - [https://developer.github.com/v3/oauth_authorizations/#get-or-create-an-authorization-for-a-specific-app](https://developer.github.com/v3/oauth_authorizations/#get-or-create-an-authorization-for-a-specific-app)
      #
      # **Example:**
      # ```
      # @client = Octokit.client("monalisa", "PASSWORD")
      # @client.create_authorization(idempotent: true, client_id: "xxxx", client_secret: "yyyy", scopes: ["user"])
      # ```
      def create_authorization(
        *,
        client_id = nil,
        client_secret = nil,
        scopes = [] of String,
        note = nil,
        note_url = nil,
        idempotent = nil,
        fingerprint = nil
      ) : Authorization
        # Techincally we can omit scopes as GitHub has a default, however the
        # API will reject us if we send a POST request with an empty body.
        if idempotent
          raise ArgumentError.new("Client ID and Secret required for idempotent authorizations") unless client_id && client_secret

          # Don't include the client_id in the body or
          # this will result in a 422.
          json = {
            client_secret: client_secret,
            scopes:        scopes,
            note:          note,
            note_url:      note_url,
          }

          if fingerprint
            res = put "authorizations/clients/#{client_id}/#{fingerprint}", {json: json}
          else
            res = put "authorizations/clients/#{client_id}", {json: json}
          end
        else
          json = {
            client_secret: client_secret,
            scopes:        scopes,
            note:          note,
            note_url:      note_url,
          }

          res = post "authorizations", {json: json}
        end

        Authorization.from_json(res)
      end

      # Update an authorization for the authenticated user.
      #
      # You can only access your own tokens, and only through
      # Basic Authentication.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/oauth_authorizations/#update-an-existing-authorization](https://developer.github.com/v3/oauth_authorizations/#update-an-existing-authorization)
      # - [https://developer.github.com/v3/oauth/#scopes](https://developer.github.com/v3/oauth/#scopes)
      #
      # **Example:**
      # ```
      # @client = Octokit.client("monalisa", "PASSWORD")
      # @client.update_authorization(999999, add_scopes: ["gist", "repo"], note: "Why not Zoidberg possibly?")
      # ```
      def update_authorization(number : Int32, **options) : Authorization
        json = options.merge({number: number})
        res = patch "authorizations/#{number}", {json: json}
        Authorization.from_json(res)
      end

      # Delete an authorization for the authenticated user.
      #
      # You can only access your own tokens, and only through
      # Basic Authentication.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/oauth_authorizations/#delete-an-authorization](https://developer.github.com/v3/oauth_authorizations/#delete-an-authorization)
      #
      # **Example:**
      # ```
      # @client = Octokit.client("monalisa", "PASSWORD")
      # @client.delete_authorization(999999)
      # ```
      def delete_authorization(number : Int32) : Bool
        boolean_from_response :delete, "authorizations/#{number}"
      end

      # Check scopes for a token.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/oauth/#scopes](https://developer.github.com/v3/oauth/#scopes)
      def scopes(token = @access_token, headers = nil) : Array(String)
        raise ArgumentError.new("Access token required") if token.nil?

        auth = {"Authorization": "token #{token}"}
        headers = headers ? headers.merge(auth) : auth

        get "user", {headers: headers}
        last_response = @last_response.not_nil!
        last_response.headers["X-OAuth-Scopes"]
          .to_s
          .split(',')
          .map(&.strip)
          .sort!
      end

      # Check if a token is valid.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/oauth_authorizations/#check-an-authorization](https://developer.github.com/v3/oauth_authorizations/#check-an-authorization)
      #
      # **Example:**
      # ```
      # @client = Octokit.client(client_id: "abcdefg12345", client_secret: "secret")
      # @client.check_application_authorization("deadbeef1234567890deadbeef987654321")
      # ```
      def check_application_authorization(token, key = client_id) : Authorization
        as_app(key, secret) do |app_client|
          app_client.get "applications/#{client_id}/tokens/#{token}"
        end
      end

      # Reset a token.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/oauth_authorizations/#reset-an-authorization](https://developer.github.com/v3/oauth_authorizations/#reset-an-authorization)
      #
      # **Example:**
      # ```
      # @client = Octokit.client(client_id: "abcdefg12345", client_secret: "secret")
      # @client.reset_application_authorization("deadbeef1234567890deadbeef987654321")
      # ```
      def reset_application_authorization(token, key = client_id) : Authorization
        as_app(key, secret) do |app_client|
          app_client.post "applications/#{client_id}/tokens/#{token}"
        end
      end

      # Revoke a token.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/oauth_authorizations/#revoke-an-authorization-for-an-application](https://developer.github.com/v3/oauth_authorizations/#revoke-an-authorization-for-an-application)
      #
      # **Example:**
      # ```
      # @client = Octokit.client(client_id: "abcdefg12345", client_secret: "secret")
      # @client.revoke_application_authorization("deadbeef1234567890deadbeef987654321")
      # ```
      def revoke_application_authorization(token, key = client_id) : Authorization
        as_app(key, secret) do |app_client|
          app_client.delete "applications/#{client_id}/tokens/#{token}"
          app_client.last_response.status_code == 204
        end
      rescue Octokit::NotFound
        false
      end

      alias_method :revoke_application_authorization, :delete_application_authorization

      # Get the URL to authorize a user for an application via the web flow.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/oauth/#web-application-flow](https://developer.github.com/v3/oauth/#web-application-flow)
      #
      # **Example:**
      # ```
      # @client.authorize_url("xxxx")
      # ```
      def authorize_url(app_id = client_id, **options) : String
        String.build do |authorize_url|
          authorize_url << (options[:endpoint]? || web_endpoint)
          authorize_url << "login/oauth/authorize?client_id=#{app_id}"

          options.to_h.each do |key, value|
            authorize_url << "&#{key}=#{URI.escape(value)}"
          end
        end
      end
    end
  end
end
