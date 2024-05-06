require "../models/repos"
require "../models/orgs"
require "../models/issues"
require "../models/users"

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

      # :nodoc:
      alias User = Models::User

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
      # @client.update_issue("watzon/cadmium", 4, assignee: "monalisa")
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
        options.merge({since: options[:since].to_rfc3339}) if options[:since].is_a?(Time)
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

      # Get a single comment attached to an issue.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/comments/#create-a-comment](https://developer.github.com/v3/issues/comments/#create-a-comment)
      #
      # **Examples:**
      #
      # Add a comment to issue #4 on watzon/cadmium
      # ```
      # Octokit.client.add_comment("watzon/cadmium", 4, "Plenty of awesome")
      # ```
      def add_comment(repo, number : Int32, comment : String)
        res = post "#{Repository.path(repo)}/issues/#{number}/comments", {json: {body: comment}}
        Models::IssueComment.from_json(res)
      end

      # Update a single comment on an issue.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/comments/#edit-a-comment](https://developer.github.com/v3/issues/comments/#edit-a-comment)
      #
      # **Examples:**
      #
      # Update comment #495536069
      # ```
      # Octokit.client.update_comment("watzon/cadmium", 495536069, "Plenty of awesome!")
      # ```
      def update_comment(repo, number : Int32, comment : String)
        res = patch "#{Repository.path(repo)}/issues/comments/#{number}", {json: {body: comment}}
        Models::IssueComment.from_json(res)
      end

      # Delete a single comment.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/comments/#delete-a-comment](https://developer.github.com/v3/issues/comments/#delete-a-comment)
      #
      # **Examples:**
      #
      # Delete comment #495536069
      # ```
      # Octokit.client.delete_comment("watzon/cadmium", 495536069)
      # ```
      def delete_comment(repo, number : Int32)
        boolean_from_response :delete, "#{Repository.path(repo)}/issues/comments/#{number}"
      end

      # Get the timeline for an issue.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/timeline/](https://developer.github.com/v3/issues/timeline/)
      #
      # **Examples:**
      #
      # Get timeline for issue #4 on watzon/cadmium
      # ```
      # Octokit.client.issue_timeline("watzon/cadmium", 4)
      # ```
      def issue_timeline(repo, number : Int32)
        headers = api_media_type(:issue_timelines)
        paginate Models::Timeline, "#{Repository.path(repo)}/issues/comments/#{number}", options: {headers: headers}
      end

      # List the available assignees for issues in a repository.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/assignees/#list-assignees](https://developer.github.com/v3/issues/assignees/#list-assignees)
      #
      # **Examples:**
      #
      # Get avaialble assignees on repository watzon/cadmium
      # ```
      # Octokit.client.list_assignees("watzon/cadmium")
      # ```
      def list_assignees(repo)
        paginate User, "#{Repository.path(repo)}/assignees"
      end

      # Add assignees to an issue.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/assignees/#add-assignees-to-an-issue](https://developer.github.com/v3/issues/assignees/#add-assignees-to-an-issue)
      #
      # **Examples:**
      #
      # Add assignees "monalisa" and "asterite" to issue #4 on watzon/cadmium
      # ```
      # Octokit.client.add_assignees("watzon/cadmium", 4, ["monalisa", "asterite"])
      # ```
      def add_assignees(repo, number : Int32, assignees : Array(String | User))
        assignees = assignees.map { |a| a.is_a?(User) ? a.login : a }
        res = post "#{Repository.path(repo)}/issues/#{number}/assignees", {json: {assignees: assignees}}
        Issue.from_json(res)
      end

      # Remove assignees from an issue.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/assignees/#remove-assignees-from-an-issue](https://developer.github.com/v3/issues/assignees/#remove-assignees-from-an-issue)
      #
      # **Examples:**
      #
      # Remove assignee "asterite" from issue #4 on watzon/cadmium
      # ```
      # Octokit.client.remove_assignees("watzon/cadmium", 4, ["asterite"])
      # ```
      def remove_assignees(repo, number : Int32, assignees : Array(String | User))
        assignees = assignees.map { |a| a.is_a?(User) ? a.login : a }
        res = post "#{Repository.path(repo)}/issues/#{number}/assignees", {json: {assignees: assignees}}
        Issue.from_json(res)
      end

      # Validate options for filtering issues and log a warning if an incorrect
      # filter is used.
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
