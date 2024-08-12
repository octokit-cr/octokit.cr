require "../models/apps"

module Octokit
  class Client
    # Methods for the Apps API
    module Apps
      # :nodoc:
      alias App = Models::App

      # Get the authenticated App
      #
      # @param options [Hash] A customizable set of options
      #
      # @see https://developer.github.com/v3/apps/#get-the-authenticated-app
      #
      # **Example:**
      # ```
      # @client = Octokit.client(bearer_token: <jwt>)
      # @client.app
      # ```
      def app(**options)
        get("app", options)
      end

      # Find all installations that belong to an App
      #
      # @param options [Hash] A customizable set of options
      #
      # @see https://developer.github.com/v3/apps/#list-installations
      #
      # @return the total_count and an array of installations
      def find_app_installations(**options) : Paginator(Octokit::Models::Installation)
        paginate(
          Octokit::Models::Installation,
          "app/installations",
          start_page: options[:page]?,
          per_page: options[:per_page]?,
          options: options
        )
      end

      # alias for `find_app_installations`
      def find_installations(**options) : Paginator(Octokit::Models::Installation)
        find_app_installations(**options)
      end

      # Create a new installation token
      #
      # @param installation [Integer] The id of a GitHub App Installation
      # @param options [Hash] A customizable set of options
      #
      # @see https://developer.github.com/v3/apps/#create-a-new-installation-token
      #
      # @return [<Sawyer::Resource>] An installation token
      def create_app_installation_access_token(installation : Int32, **options)
        post("app/installations/#{installation}/access_tokens", options)
      end

      # alias for `create_app_installation_access_token`
      def create_installation_access_token(installation : Int32, **options)
        create_app_installation_access_token(installation, **options)
      end
    end
  end
end
