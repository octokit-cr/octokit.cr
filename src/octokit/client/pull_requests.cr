require "uri"
require "../models/repos"
require "../models/pulls"

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
      # def close_pull_request(repo : String, number : Int64, **options)
        # TODO
      # end

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
