require "uri"
require "../models/repos"
require "../models/pulls"
require "../models/commits"
require "../models/pull_comments"
require "../models/repo_commits"

module Octokit
  class Client
    # Methods for the Pull Requests API
    #
    # All "repo" params are constructed in the format of `<organization>/<repository>`
    #
    # **See Also:**
    # - [https://docs.github.com/en/rest/pulls/pulls?apiVersion=2022-11-28](https://docs.github.com/en/rest/pulls/pulls?apiVersion=2022-11-28)

    module PullRequests
      # :nodoc:
      alias Repository = Models::Repository
      # :nodoc:
      alias PullRequest = Octokit::Models::PullRequest
      # :nodoc:
      alias Commit = Octokit::Models::Commit
      # :nodoc:
      alias PullRequestComment = Octokit::Models::PullRequestComment
      # :nodoc:
      alias CommitFile = Octokit::Models::CommitFile

      # Valid filters for PullRequests
      FILTERS = ["all", "assigned", "created", "mentioned", "subscribed"]

      # Valid states for PullRequests
      STATES = ["all", "open", "closed"]

      # Valid sort for PullRequests
      SORTS = ["created", "updated", "comments"]

      # Valid directions in which to sort PullRequests
      DIRECTIONS = ["asc", "desc"]

      # The default options for listing pull requests
      DEFAULTS = {
        state:     "open",
        sort:      "created",
        direction: "desc",
      }

      # List pull requests for a repository
      #
      # **See Also:**
      # - [https://developer.github.com/v3/pulls/#list-pull-requests](https://developer.github.com/v3/pulls/#list-pull-requests)
      #
      # **Examples:**
      #
      # ```
      # Octokit.pull_requests("crystal-lang/crystal")
      # Octokit.pull_requests("crystal-lang/crystal", state: "closed")
      # ```
      def pull_requests(repo : String, **options) : Paginator(PullRequest)
        validate_options(options)
        paginate(
          PullRequest,
          "#{Repository.path(repo)}/pulls",
          options: {params: DEFAULTS.merge(options)}
        )
      end

      alias_method :pull_requests, :pulls

      # Create a pull request
      #
      # **See Also:**
      # - [https://developer.github.com/v3/pulls/#create-a-pull-request](https://developer.github.com/v3/pulls/#create-a-pull-request)
      #
      # **Examples:**
      #
      # ```
      # Octokit.create_pull_request("crystal-lang/crystal", "master", "new-branch", "Title", "Body")
      # ```
      def create_pull_request(repo : String, base : String, head : String, title : String, body : String, **options)
        options = {base: base, head: head, title: title, body: body}.merge(options)
        post "#{Repository.path repo}/pulls", {json: options}
      end

      # Create a pull request for an issue
      #
      # **See Also:**
      # - [https://developer.github.com/v3/pulls/#create-a-pull-request](https://developer.github.com/v3/pulls/#create-a-pull-request)
      #
      # **Examples:**
      #
      # ```
      # Octokit.create_pull_request_for_issue("crystal-lang/crystal", "master", "new-branch", 123)
      # ```
      def create_pull_request_for_issue(repo : String, base : String, head : String, issue : Int32, **options)
        options = {base: base, head: head, issue: issue}.merge(options)
        post "#{Repository.path repo}/pulls", {json: options}
      end

      # Update a pull request
      #
      # **See Also:**
      # - [https://developer.github.com/v3/pulls/#update-a-pull-request](https://developer.github.com/v3/pulls/#update-a-pull-request)
      #
      # **Examples:**
      #
      # ```
      # Octokit.update_pull_request("crystal-lang/crystal", 123, title: "New Title", body: "New Body")
      # ```
      def update_pull_request(repo : String, number : Int64, **options)
        patch "#{Repository.path repo}/pulls/#{number}", {json: options}
      end

      # Close a pull request
      #
      # **See Also:**
      # - [https://developer.github.com/v3/pulls/#update-a-pull-request](https://developer.github.com/v3/pulls/#update-a-pull-request)
      #
      # **Examples:**
      #
      # ```
      # Octokit.close_pull_request("crystal-lang/crystal", 123)
      # ```
      def close_pull_request(repo : String, number : Int64, **options)
        options = {state: "closed"}.merge(options)
        patch "#{Repository.path repo}/pulls/#{number}", {json: options}
      end

      # List commits on a pull request
      #
      # **See Also:**
      # - [https://developer.github.com/v3/pulls/#list-commits-on-a-pull-request](https://developer.github.com/v3/pulls/#list-commits-on-a-pull-request)
      #
      # **Examples:**
      #
      # ```
      # Octokit.pull_request_commits("crystal-lang/crystal", 123)
      # ```
      def pull_request_commits(repo : String, number : Int64, **options) : Paginator(Commit)
        paginate(
          Commit,
          "#{Repository.path(repo)}/pulls/#{number}/commits",
          options: {params: options}
        )
      end

      alias_method :pull_request_commits, :pull_commits

      # List review comments on a pull request
      #
      # This method applies to pull request review comments. Pull request review comments are NOT the same as standard comments left on PRs - those are issue comments.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/pulls/comments/#list-comments-on-a-pull-request](https://developer.github.com/v3/pulls/comments/#list-comments-on-a-pull-request)
      #
      # **Examples:**
      #
      # ```
      # Octokit.pull_requests_comments("crystal-lang/crystal", 123)
      # ```
      def pull_requests_comments(repo : String, number : Int64, **options) : Paginator(PullRequestComment)
        paginate(
          PullRequestComment,
          "#{Repository.path(repo)}/pulls/#{number}/comments",
          options: {params: options}
        )
      end

      alias_method :pull_requests_comments, :reviews_comments

      # List comments on a pull request
      #
      # This method applies to pull request review comments. Pull request review comments are NOT the same as standard comments left on PRs - those are issue comments.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/pulls/comments/#list-comments-on-a-pull-request](https://developer.github.com/v3/pulls/comments/#list-comments-on-a-pull-request)
      #
      # **Examples:**
      #
      # ```
      # Octokit.pull_request_comments("crystal-lang/crystal", 123)
      # ```
      def pull_request_comments(repo : String, number : Int64, **options) : Paginator(PullRequestComment)
        paginate(
          PullRequestComment,
          "#{Repository.path(repo)}/pulls/#{number}/comments",
          options: {params: options}
        )
      end

      alias_method :pull_request_comments, :pull_comments
      alias_method :pull_request_comments, :review_comments

      # Get a single comment on a pull request
      #
      # This method applies to pull request review comments. Pull request review comments are NOT the same as standard comments left on PRs - those are issue comments.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/pulls/comments/#get-a-single-comment](https://developer.github.com/v3/pulls/comments/#get-a-single-comment)
      #
      # **Examples:**
      #
      # ```
      # Octokit.pull_request_comment("crystal-lang/crystal", 456)
      # ```
      def pull_request_comment(repo : String, comment_id : Int64, **options)
        get "#{Repository.path(repo)}/pulls/comments/#{comment_id}", {params: options}
      end

      alias_method :pull_request_comment, :pull_comment
      alias_method :pull_request_comment, :review_comment

      # Create a comment on a pull request
      #
      # This method applies to pull request review comments. Pull request review comments are NOT the same as standard comments left on PRs - those are issue comments.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/pulls/comments/#create-a-comment](https://developer.github.com/v3/pulls/comments/#create-a-comment)
      #
      # - repo (String) — A GitHub repository
      # - number (Integer) — Pull request number
      # - body (String) — Comment content
      # - commit_id (String) — Sha of the commit to comment on
      # - path (String) — Relative path of the file to comment on
      # - line (Integer) — Line number in the diff to comment on
      # - side (String) — Side of the diff that the comment applies to (LEFT or RIGHT)
      # - start_line (Integer) — Start line for multi-line comments
      # - start_side (String) — Start side for multi-line comments (LEFT or RIGHT)
      # - in_reply_to (Integer) — ID of the review comment to reply to
      # - subject_type (String) — Level at which the comment is targeted (line or file)
      #
      # **Examples:**
      #
      # ```
      # Octokit.create_pull_request_comment("crystal-lang/crystal", 123, "Comment body", "commit_id", "path/to/file.txt", 1, side: "RIGHT")
      # ```
      def create_pull_request_comment(
        repo : String,
        number : Int64,
        body : String,
        commit_id : String,
        path : String,
        line : Int32,
        **options
      )
        options = {
          body:      body,
          commit_id: commit_id,
          path:      path,
          line:      line,
        }.merge(options)
        post "#{Repository.path repo}/pulls/#{number}/comments", {json: options}
      end

      alias_method :create_pull_request_comment, :create_pull_comment
      alias_method :create_pull_request_comment, :create_review_comment

      # Create a reply to a comment on a pull request
      #
      # **See Also:**
      # - [https://developer.github.com/v3/pulls/comments/#create-a-reply-to-a-comment](https://developer.github.com/v3/pulls/comments/#create-a-reply-to-a-comment)
      #
      # **Examples:**
      #
      # ```
      # Octokit.create_pull_request_comment_reply("crystal-lang/crystal", 123, "Comment body", 456)
      # ```
      def create_pull_request_comment_reply(repo : String, number : Int64, body : String, in_reply_to : Int64, **options)
        options = {body: body, in_reply_to: in_reply_to}.merge(options)
        post "#{Repository.path repo}/pulls/#{number}/comments", {json: options}
      end

      alias_method :create_pull_request_comment_reply, :create_pull_reply
      alias_method :create_pull_request_comment_reply, :create_review_reply

      # Update a comment on a pull request
      #
      # **See Also:**
      # - [https://developer.github.com/v3/pulls/comments/#update-a-comment](https://developer.github.com/v3/pulls/comments/#update-a-comment)
      #
      # **Examples:**
      #
      # ```
      # Octokit.update_pull_request_comment("crystal-lang/crystal", 456, "New comment body")
      # ```
      def update_pull_request_comment(repo : String, comment_id : Int64, body : String, **options)
        options = {body: body}.merge(options)
        patch "#{Repository.path repo}/pulls/comments/#{comment_id}", {json: options}
      end

      alias_method :update_pull_request_comment, :update_pull_comment
      alias_method :update_pull_request_comment, :update_review_comment

      # Delete a comment on a pull request
      #
      # **See Also:**
      # - [https://developer.github.com/v3/pulls/comments/#delete-a-comment](https://developer.github.com/v3/pulls/comments/#delete-a-comment)
      #
      # **Examples:**
      #
      # ```
      # Octokit.delete_pull_request_comment("crystal-lang/crystal", 456)
      # ```
      def delete_pull_request_comment(repo : String, comment_id : Int64, **options)
        delete "#{Repository.path repo}/pulls/comments/#{comment_id}", {params: options}
      end

      alias_method :delete_pull_request_comment, :delete_pull_comment
      alias_method :delete_pull_request_comment, :delete_review_comment

      # List files on a pull request
      #
      # **See Also:**
      # - [https://developer.github.com/v3/pulls/#list-pull-requests-files](https://developer.github.com/v3/pulls/#list-pull-requests-files)
      #
      # **Examples:**
      #
      # ```
      # Octokit.pull_request_files("crystal-lang/crystal", 123)
      # ```
      def pull_request_files(repo : String, number : Int64, **options) : Paginator(CommitFile)
        paginate(
          CommitFile,
          "#{Repository.path(repo)}/pulls/#{number}/files",
          options: {params: options}
        )
      end

      alias_method :pull_request_files, :pull_files

      # Update a pull request branch
      #
      # **See Also:**
      # - [https://developer.github.com/v3/pulls/#update-a-pull-request-branch](https://developer.github.com/v3/pulls/#update-a-pull-request-branch)
      #
      # **Examples:**
      # ```
      # Octokit.update_pull_request_branch("crystal-lang/crystal", 123)
      # ```
      def update_pull_request_branch(repo : String, number : Int64, **options) : Bool
        boolean_from_response(
          :put,
          "#{Repository.path(repo)}/pulls/#{number}/update-branch"
        )
      end

      # Merge a pull request
      #
      # **See Also:**
      # - [https://developer.github.com/v3/pulls/#merge-a-pull-request](https://developer.github.com/v3/pulls/#merge-a-pull-request)
      #
      # **Examples:**
      #
      # ```
      # Octokit.merge_pull_request("crystal-lang/crystal", 123, "Commit message")
      # ```
      def merge_pull_request(repo : String, number : Int64, commit_message : String, **options)
        options = {commit_message: commit_message}.merge(options)
        put "#{Repository.path repo}/pulls/#{number}/merge", {json: options}
      end

      # Check if a pull request has been merged
      #
      # **See Also:**
      # - [https://developer.github.com/v3/pulls/#get-if-a-pull-request-has-been-merged](https://developer.github.com/v3/pulls/#get-if-a-pull-request-has-been-merged)
      #
      # **Examples:**
      #
      # ```
      # Octokit.pull_merged?("crystal-lang/crystal", 123)
      # ```
      def pull_merged?(repo : String, number : Int64, **options) : Bool
        boolean_from_response(
          :get,
          "#{Repository.path(repo)}/pulls/#{number}/merge",
          options: {params: options}
        )
      end

      alias_method :pull_merged?, :pull_request_merged?

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
