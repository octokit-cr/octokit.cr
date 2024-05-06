module Octokit
  class Client
    # Methods for the Users API
    #
    # **See Also:**
    # - [https://developer.github.com/v3/users/](https://developer.github.com/v3/users/)
    module Users
      # :nodoc:
      alias User = Models::User

      # List all GitHub users
      #
      # This provides a list of every user, in the order that they signed up
      # for GitHub.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/users/#get-all-users](https://developer.github.com/v3/users/#get-all-users)
      def all_users
        res = paginate "users"
        User.from_json(res)
      end

      # Get a single user
      #
      # **See Also:**
      # - [https://developer.github.com/v3/users/#get-a-single-user](https://developer.github.com/v3/users/#get-a-single-user)
      # - [https://developer.github.com/v3/users/#get-the-authenticated-user](https://developer.github.com/v3/users/#get-the-authenticated-user)
      def user(user = nil)
        res = get User.path(user)
        User.from_json(res)
      end

      # Retrieve access token
      #
      # **Example:**
      # ```
      # Octokit.client.exchange_code_for_token("aaaa", "xxxx", "yyyy", {accept: "application/json"})
      # ```
      #
      # **See Also:**
      # - [https://developer.github.com/v3/oauth/#web-application-flow](https://developer.github.com/v3/oauth/#web-application-flow)
      def exchange_code_for_token(code, app_id = client_id, app_secret = client_secret)
        options = {
          code:          code,
          client_id:     app_id,
          client_secret: app_secret,
          headers:       {
            content_type: "application/json",
            accept:       "application/json",
          },
        }

        res = post "#{web_endpoint}/login/oauth/access_token", options
        Models::AccessToken.from_json(res)
      end

      # Validate user username and password
      def validate_credentials(options = nil)
        !self.class.new(options).user.nil?
      rescue Octokit::Error::Unauthorized
        false
      end

      # Update the authenticated user
      #
      # **Example:**
      # ```
      # Octokit.client.update_user(name: "Chris Watson", email: "cawatson1993@gmail.com", company: "Manas Tech", location: "Buenos Aires", hireable: false)
      # ```
      #
      # **See Also:**
      # - [https://developer.github.com/v3/users/#update-the-authenticated-user](https://developer.github.com/v3/users/#update-the-authenticated-user)
      def update_user(**options)
        res = patch "user", {json: options}
        User.from_json(res)
      end

      # Get a user's followers
      #
      # **Example:**
      # ```
      # Octokit.client.followers("monalisa")
      # ```
      #
      # **See Also:**
      # - [https://developer.github.com/v3/users/followers/#list-followers-of-a-user](https://developer.github.com/v3/users/followers/#list-followers-of-a-user)
      def followers(user, **options)
        res = paginate User, "#{User.path(user)}/followers", **options
        Array(Models::Follower).from_json(res)
      end

      # Get a list of users the user is following
      #
      # **Example:**
      # ```
      # Octokit.client.following("monalisa")
      # ```
      #
      # **See Also:**
      # - [https://developer.github.com/v3/users/followers/#list-users-followed-by-another-user](https://developer.github.com/v3/users/followers/#list-users-followed-by-another-user)
      def following(user, **options)
        res = paginate User, "#{User.path(user)}/following", **options
        Array(Models::Follower).from_json(res)
      end

      # Check if you is following a user. Alternatively check if a given user
      # is following a target user.
      #
      # **Examples:**
      # ```
      # @client.follows?("asterite")
      # @client.follows?("asterite", "waj")
      # ```
      #
      # **Note:** Requires an authenticated user.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/users/followers/#check-if-you-are-following-a-user](https://developer.github.com/v3/users/followers/#check-if-you-are-following-a-user)
      # - [https://developer.github.com/v3/users/followers/#check-if-one-user-follows-another](https://developer.github.com/v3/users/followers/#check-if-one-user-follows-another)
      def follows?(user, target = nil)
        if !target
          target = user
          user = nil
        end

        boolean_from_response :get, "#{User.path(user)}/following/#{target}"
      end

      # Follow a user.
      #
      # **Example:**
      # ```
      # @client.follow("monalisa")
      # ```
      #
      # **Note:** Requires an authenticated user.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/users/followers/#follow-a-user](https://developer.github.com/v3/users/followers/#follow-a-user)
      def follow(user)
        boolean_from_response :put, "user/following/#{user}"
      end

      # Unfollow a user.
      #
      # **Example:**
      # ```
      # @client.unfollow("monalisa")
      # ```
      #
      # **Note:** Requires an authenticated user.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/users/followers/#unfollow-a-user](https://developer.github.com/v3/users/followers/#unfollow-a-user)
      def unfollow(user)
        boolean_from_response :delete, "user/following/#{user}"
      end

      # Get a list of repos starred by a user.
      #
      # **Example:**
      # ```
      # Octokit.client.starred("monalisa")
      # ```
      #
      # **See Also:**
      # - [https://developer.github.com/v3/activity/starring/#list-repositories-being-starred](https://developer.github.com/v3/activity/starring/#list-repositories-being-starred)
      def starred(user = login, **options)
        paginate User, user_path(user, "starred"), **options
      end

      # Check if you are starring a repo.
      #
      # **Example:**
      # ```
      # @client.starred?("watzon/octokit")
      # ```
      #
      # **Note:** Requires an authenticated client.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/activity/starring/#check-if-you-are-starring-a-repository](https://developer.github.com/v3/activity/starring/#check-if-you-are-starring-a-repository)
      def starred?(repo)
        boolean_from_response :get, "user/starred/#{repo}"
      end

      # Get a public key.
      #
      # **Examples:**
      # ```
      # @client.key(1)
      #
      # # Retrieve public key contents
      # public_key = @client.key(1)
      # public_key.key
      # # => Error
      #
      # public_key[:key]
      # # => "ssh-rsa AAA..."
      # ```
      #
      # **Note:** when using dot notation to retrieve the values, ruby will return
      # the hash key for the public keys value instead of the actual value, use
      # symbol or key string to retrieve the value. See example.
      #
      # **Note:** Requires an authenticated client.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/users/keys/#get-a-single-public-key](https://developer.github.com/v3/users/keys/#get-a-single-public-key)
      def key(key_id)
        get "user/keys/#{key_id}"
      end

      # Get a list of public keys for a user.
      #
      # **Examples:**
      # ```
      # @client.keys
      # @client.keys("monalisa")
      # ```
      # **Note:** Requires an authenticated client.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/users/keys/#list-your-public-keys](https://developer.github.com/v3/users/keys/#list-your-public-keys)
      # - [https://developer.github.com/v3/users/keys/#list-public-keys-for-a-user](https://developer.github.com/v3/users/keys/#list-public-keys-for-a-user)
      def keys(user = nil)
        paginate User, "#{User.path user}/keys", **options
      end

      # Add public key to user account.
      #
      # **Example:**
      # ```
      # @client.add_key("Personal projects key", "ssh-rsa AAA...")
      # ```
      #
      # **Note:** Requires authenticated client.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/users/keys/#create-a-public-key](https://developer.github.com/v3/users/keys/#create-a-public-key)
      def add_key(title, key)
        options = {title: title, key: key}
        post "user/keys", {json: options}
      end

      # Delete a public key.
      #
      # **Example:**
      # ```
      # @client.remove_key(1)
      # ```
      #
      # **Note:** Requires an authenticated client.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/users/keys/#delete-a-public-key](https://developer.github.com/v3/users/keys/#delete-a-public-key)
      def remove_key(id)
        boolean_from_response :delete, "user/keys/#{id}"
      end

      # List email addresses for a user.
      #
      # **Example:**
      # ```
      # @client.emails
      # ```
      #
      # **Note:** Requires an authenticated client.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/users/emails/#list-email-addresses-for-a-user](https://developer.github.com/v3/users/emails/#list-email-addresses-for-a-user)
      def emails(**options)
        paginate User, "user/emails", **options
      end

      # List public email addresses for a user.
      #
      # **Example:**
      # ```
      # @client.public_emails
      # ```
      #
      # **Note:** Requires an authenticated client.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/users/emails/#list-public-email-addresses-for-a-user](https://developer.github.com/v3/users/emails/#list-public-email-addresses-for-a-user)
      def public_emails(**options)
        paginate User, "user/public_emails", **options
      end

      # Add email address to user.
      #
      # **Example:**
      # ```
      # @client.add_email("new_email@user.com")
      # ```
      #
      # **Note:** Requires authenticated client.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/users/emails/#add-email-addresses](https://developer.github.com/v3/users/emails/#add-email-addresses)
      def add_email(email)
        email = [email] unless email.is_a?(Array)
        post "user/emails", email
      end

      # Remove email from user.
      #
      # **Example:**
      # ```
      # @client.remove_email("old_email@user.com")
      # ```
      #
      # **Note:** Requires authenticated client.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/users/emails/#delete-email-addresses](https://developer.github.com/v3/users/emails/#delete-email-addresses)
      def remove_email(email)
        email = [email] unless email.is_a?(Array)
        boolean_from_response :delete, "user/emails", email
      end

      # Toggle the visibility of the users primary email addresses.
      #
      # **Example:**
      # ```
      # @client.toggle_email_visibility([{email: "email@user.com", visibility: "private"}])
      # ```
      #
      # **Note:** Requires authenticated client.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/users/emails/#toggle-primary-email-visibility](https://developer.github.com/v3/users/emails/#toggle-primary-email-visibility)
      def toggle_email_visibility(options)
        res = patch "user/email/visibility", {json: options}
        Array(Models::UserEmail).from_json(res)
      end

      # List repositories being watched by a user.
      #
      # **Example:**
      # ```
      # @client.subscriptions("monalisa")
      # ```
      #
      # **See Also:**
      # - [https://developer.github.com/v3/activity/watching/#list-repositories-being-watched](https://developer.github.com/v3/activity/watching/#list-repositories-being-watched)
      def subscriptions(user = login, **options)
        paginate User, user_path(user, "subscriptions"), **options
      end

      # Convenience method for constructing a user specific path, if the user is logged in
      private def user_path(user, path)
        if user == login && user_authenticated?
          "user/#{path}"
        else
          "#{User.path user}/#{path}"
        end
      end
    end
  end
end
