module Octokit
  class Client
    module Users
      # List all GitHub users
      #
      # This provides a list of every user, in the order that they signed up
      # for GitHub.
      #
      # API Reference:  https://developer.github.com/v3/users/#get-all-users
      def all_users(options = nil)
        paginate "users", options
      end

      # Get a single user
      #
      # API Reference: https://developer.github.com/v3/users/#get-a-single-user
      # API Reference: https://developer.github.com/v3/users/#get-the-authenticated-user
      def user(user = nil, options = nil)
        get Models::User.path(user), options
      end

      # Retrieve access token
      #
      # API Reference:  https://developer.github.com/v3/oauth/#web-application-flow
      #
      # Example:
      # ```
      # Octokit.exchange_code_for_token("aaaa", "xxxx", "yyyy", {accept: "application/json"})
      # ```
      def exchange_code_for_token(code, app_id = client_id, app_secret = client_secret, options = nil)
        options = options.merge({
          code:          code,
          client_id:     app_id,
          client_secret: app_secret,
          headers:       {
            content_type: "application/json",
            accept:       "application/json",
          },
        })

        post "#{web_endpoint}/login/oauth/access_token", options
      end

      # Validate user username and password
      def validate_credentials(options = nil)
        !self.class.new(options).user.nil?
      rescue Octokit::Unauthorized
        false
      end

      # Update the authenticated user
      #
      # API Reference:  https://developer.github.com/v3/users/#update-the-authenticated-user
      #
      # Example
      # ```
      # Octokit.update_user(name: "Chris Watson", email: "cawatson1993@gmail.com", company: "Manas Tech", location: "Buenos Aires", hireable: false)
      # ```
      def update_user(*options)
        patch "user", options
      end
    end
  end
end
