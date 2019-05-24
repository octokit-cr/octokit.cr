module Octokit
  class Client
    # Methods for the Issues API
    #
    # **See Also:**
    # - [https://developer.github.com/v3/issues/](https://developer.github.com/v3/issues/)
    module Issues
      # :nodoc:
      alias Repository = Models::Repository

      # :nodoc:
      alias Organization = Models::Organization

      # :nodoc:
      alias Issue = Models::Issue

      # Valid filters for Issues
      FILTERS = ["all", "assigned", "created", "mentioned", "subscribed"]

      # Valid states for Issues
      STATES = ["all", "open", "closed"]

      # Valid sort for Issues
      SORTS = ["created", "updated", "comments"]

      # Valid directions in which to sort Issues
      DIRECTIONS = ["asc", "desc"]

      # List issues for the authenticated user or repository
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/#list-issues-for-a-repository](https://developer.github.com/v3/issues/#list-issues-for-a-repository)
      # - [https://developer.github.com/v3/issues/#list-issues](https://developer.github.com/v3/issues/#list-issues)
      #
      # **Example:**
      #
      # List issues for a repository
      # ```
      # Octokit.client.list_issues("watzon/cadmium")
      # ```
      #
      # List issues for the authenticated user across repositories
      # ```
      # @client = Octokit::Client.new(login: "foo", password: "bar")
      # @client.list_issues
      # ```
      def list_issues(repo = nil, **options)
        validate_options(options)
        path = repo ? "#{Repository.path(repo)}/issues" : "issues"
        paginate Issue, path, options: {json: options}
      end

      # List all user issues across owned and member repositories for the
      # authenticated user.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/#list-issues](https://developer.github.com/v3/issues/#list-issues)
      #
      # **Example:**
      #
      # List issues for the authenticated user across owned and member repositories.
      # ```
      # @client = Octokit::Client.new(login: "foo", password: "bar")
      # @client.user_issues
      # ```
      def user_issues(**options)
        validate_options(options)
        paginate Issue, "user/issues", options: {json: options}
      end

      # List all user issues for a given organization for the authenticated user.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/#list-issues](https://developer.github.com/v3/issues/#list-issues)
      #
      # **Example:**
      #
      # List all issues for a given organization for the authenticated user
      # ```
      # @client = Octokit::Client.new(login: "foo", password: "bar")
      # @client.org_issues
      # ```
      def org_issues(org, **options)
        validate_options(options)
        paginate Issue, "#{Organization.path(org)}/issues", options: {json: options}
      end

      # Create an issue for a repository.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/#create-an-issue](https://developer.github.com/v3/issues/#create-an-issue)
      #
      # **Example:**
      #
      # Create a new Issues for a repository
      # ```
      # @client = Octokit::Client.new(login: "foo", password: "bar")
      # @client.create_issue("watzon/cadmium", "Not enough awesome", "You heard me.")
      # ```
      def create_issue(repo, title, body, **options)
        params = {title: title, body: body, labels: [] of String}.merge(options)
        res = post "#{Repository.path(repo)}/issues", {json: params}
        Issue.from_json(res)
      end

      alias_method :create_issue, :open_issue

      # Get a single issue from a repository
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/#get-a-single-issue](https://developer.github.com/v3/issues/#get-a-single-issue)
      #
      # **Example:**
      #
      # Get issue #4 from watzon/cadmium
      # ```
      # Octokit.client.issue("watzon/cadmium", 4)
      # ```
      def issue(repo, number : Int32)
        res = get "#{Repository.path(repo)}/issues/#{number}"
        Issue.from_json(res)
      end

      # Close an issue
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/#edit-an-issue](https://developer.github.com/v3/issues/#edit-an-issue)
      #
      # **Example:**
      #
      # Close issue #4 from watzon/cadmium
      # ```
      # @client.close_issue("watzon/cadmium", 4)
      # ```
      def close_issue(repo, number : Int32, **options)
        res = patch "#{Repository.path(repo)}/issues/#{number}", {json: options.merge({state: closed})}
        Issue.from_json(res)
      end

      # Repoen an issue
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/#edit-an-issue](https://developer.github.com/v3/issues/#edit-an-issue)
      #
      # **Example:**
      #
      # Repoen issue #4 from watzon/cadmium
      # ```
      # @client.reopen_issue("watzon/cadmium", 4)
      # ```
      def reopen_issue(repo, number : Int32, **options)
        res = patch "#{Repository.path(repo)}/issues/#{number}", {json: options.merge({state: open})}
        Issue.from_json(res)
      end

      # Lock an issue's conversation, limiting it to collaborators
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/#edit-an-issue](https://developer.github.com/v3/issues/#edit-an-issue)
      #
      # **Example:**
      #
      # Lock issue #4 from watzon/cadmium
      # ```
      # @client.lock_issue("watzon/cadmium", 4)
      # ```
      def lock_issue(repo, number : Int32, **options)
        boolean_from_response :put, "#{Repository.path(repo)}/issues/#{number}/lock", {json: options}
      end

      # Unlock an issue's conversation, opening it to all viewers
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/#edit-an-issue](https://developer.github.com/v3/issues/#edit-an-issue)
      #
      # **Example:**
      #
      # Lock issue #4 from watzon/cadmium
      # ```
      # @client.unlock_issue("watzon/cadmium", 4)
      # ```
      def unlock_issue(repo, number : Int32, **options)
        boolean_from_response :delete, "#{Repository.path(repo)}/issues/#{number}/lock", {json: options}
      end

      # Update an issue
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/#edit-an-issue](https://developer.github.com/v3/issues/#edit-an-issue)
      #
      # **Examples:**
      #
      # Change the title of issue #4
      # ```
      # @client.update_issue("watzon/cadmium", 4, title: "New title")
      # ```
      #
      # Change only the assignee of issue #4
      # ```
      # @client.update_issue("watzon/cadmium", 4, assignee: "watzon")
      # ```
      def update_issue(repo, number : Int32, **options)
        res = patch "#{Repository.path(repo)}/issues/#{number}", {json: options}
        Issue.from_json(res)
      end

      # Get all comments attached to issues for the repository.
      #
      # By default, Issue Comments are ordered by ascending ID.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/comments/#list-comments-in-a-repository](https://developer.github.com/v3/issues/comments/#list-comments-in-a-repository)
      #
      # **Examples:**
      #
      # Get the comments for issues in the cadmium repository
      # ```
      # @client.issues_comments("watzon/cadmium")
      # ```
      #
      # Get issues comments, sort by updated descending since a time
      # ```
      # @client.issues_comments("watzon/cadmium", sort: :desc, direction: :asc, since: "2010-05-04T23:45:02Z")
      # ```
      def issues_comments(repo, number : Int32, **options)
        validate_options(options)
        options.merge({since: options[:since].to_rfc3339}) if options[:since] === Time
        res = patch "#{Repository.path(repo)}/issues/#{number}", {json: options}
        Issue.from_json(res)
      end

      # Get all comments attached to an issue.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/comments/#list-comments-on-an-issue](https://developer.github.com/v3/issues/comments/#list-comments-on-an-issue)
      #
      # **Examples:**
      #
      # Get the comments for issue #4 from watzon/cadmium
      # ```
      # Octokit.client.issue_comments("watzon/cadmium", 4)
      # ```
      def issue_comments(repo, number : Int32)
        headers = api_media_type(:reactions)
        paginate Models::IssueComment, "#{Repository.path(repo)}/issues/#{number}/comments", options: {headers: headers}
      end

      # Get a single comment attached to an issue.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/comments/#get-a-single-comment](https://developer.github.com/v3/issues/comments/#get-a-single-comment)
      #
      # **Examples:**
      #
      # Get comment #495536069 from an issue on watzon/cadmium
      # ```
      # Octokit.client.issue_comment("watzon/cadmium", 495536069)
      # ```
      def issue_comment(repo, number : Int32)
        headers = api_media_type(:reactions)
        res = get "#{Repository.path(repo)}/issues/comments/#{number}", {headers: headers}
        Models::IssueComment.from_json(res)
      end

      protected def validate_options(options)
        if filter = options[:filter]?
          unless FILTERS.includes?(filter.to_s)
            octokit_warn "'#{filter}' is not a valid Issue filter. Valid values are: #{FILTERS}"
          end
        end

        if state = options[:state]?
          unless STATES.includes?(state.to_s)
            octokit_warn "'#{state}' is not a valid Issue state. Valid values are: #{STATES}"
          end
        end

        if sort = options[:sort]?
          unless SORTS.includes?(sort.to_s)
            octokit_warn "'#{sort}' is not a valid Issue sort. Valid values are: #{SORTS}"
          end
        end

        if direction = options[:direction]?
          unless DIRECTIONS.includes(direction.to_s)
            octokit_warn "'#{direction}' is not a valid Issue sort direction. Valid values are: #{DIRECTIONS}"
          end
        end
      end
    end
  end
end
