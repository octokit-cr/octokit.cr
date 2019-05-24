require "http/params"

module Octokit
  class Client
    # Methods for the PubSubHubbub API
    #
    # **Note:** The pubsub api requires clients to be OAuth authenticated.
    #
    # **See Also:**
    # - [https://developer.github.com/v3/repos/hooks/#pubsubhubbub](https://developer.github.com/v3/repos/hooks/#pubsubhubbub)
    module PubSubHubbub
      # Subscribe to a pubsub topic
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/hooks/#subscribing](https://developer.github.com/v3/repos/hooks/#subscribing)
      #
      # **Example:**
      #
      # Subscribe to push events from one of your repositories, having an email sent when fired.
      # ```
      # @client = Octokit.client.(oauth_token: "token")
      # @client.subscribe("https://github.com/watzon/cadmium/events/push", "github://Email?address=chris@watzon.me")
      # ```
      def subscribe(topic, callback, secret = nil)
        options = {
          "hub.callback": callback,
          "hub.mode":     "subscribe",
          "hub.topic":    topic,
        }

        options = options.merge({"hub.secret": secret}) unless secret.nil?
        pub_sub_hubbub_request(options)
      end

      # Unsubscribe from a pubsub topic
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/hooks/#subscribing](https://developer.github.com/v3/repos/hooks/#subscribing)
      #
      # **Example:**
      #
      # Unsubscribe to push events from one of your repositories, no longer having an email sent when fired
      # ```
      # @client = Octokit.client(oauth_token: "token")
      # @client.unsubscribe("https://github.com/watzon/cadmium/events/push", "github://Email?address=chris@watzon.me")
      # ```
      def unsubscribe(topic, callback)
        options = {
          "hub.callback": callback,
          "hub.mode":     "unsubscribe",
          "hub.topic":    topic,
        }

        pub_sub_hubbub_request(options)
      end

      # Subscribe to a repository through pubsub.
      #
      # **Note:** A list of services is available @
      # [https://github.com/github/github-services/tree/master/docs](https://github.com/github/github-services/tree/master/docs).
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/hooks/#subscribing](https://developer.github.com/v3/repos/hooks/#subscribing)
      #
      # **Example:**
      #
      # Subscribe to push events to one of your repositories to Travis-CI
      # ```
      # @client = Octokit.client.(oauth_token: "token")
      # @client.subscribe_service_hook("watzon/cadmium", "Travis", { :token => "test", :domain => "domain", :user => "user" })
      # ```
      def subscribe_service_hook(
        repo,
        service_name,
        service_arguments = {} of String => String,
        secret = nil
      )
        topic = "#{File.join(Octokit.web_endpoint, Repository.new(repo))}/events/push"
        callback = "github://#{service_name}?#{HTTP::Params.encode(service_arguments)}"
        subscribe(topic, callback, secret)
      end

      # Unsubscribe from a repository through pubsub.
      #
      # **Note:** A list of services is available @
      # [https://github.com/github/github-services/tree/master/docs](https://github.com/github/github-services/tree/master/docs).
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/hooks/#subscribing](https://developer.github.com/v3/repos/hooks/#subscribing)
      #
      # **Example:**
      #
      # Subscribe to push events to one of your repositories to Travis-CI
      # ```
      # @client = Octokit.client.(oauth_token: "token")
      # @client.unsubscribe_service_hook("watzon/cadmium", "Travis")
      # ```
      def unsubscribe_service_hook(
        repo,
        service_name
      )
        topic = "#{File.join(Octokit.web_endpoint, Repository.new(repo))}/events/push"
        callback = "github://#{service_name}"
        unsubscribe(topic, callback)
      end

      # Send the pubsub requests as form-urlencoded data and ensure that
      # they are token authenticated before doing so.
      protected def pub_sub_hubbub_request(options)
        ensure_token_authenticated!
        headers = {"Content-Type": "application/x-www-form-urlencoded"}
        boolean_from_response :post, "hub", {headers: headers, form_data: options}
      end
    end
  end
end
