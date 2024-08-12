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

      # List pull requests for a repository
      #
      # **See Also:**
      # - [https://developer.github.com/v3/pulls/#list-pull-requests](https://developer.github.com/v3/pulls/#list-pull-requests)
      #
      # **Examples:**
      #
      # ```
      # Octokit.pull_requests("crystal-lang/crystal")
      # ```
      def pull_requests(repo : String, **options) : Paginator(PullRequest)
        paginate PullRequest, "#{Repository.path(repo)}/pulls", **options
      end

      alias_method :pull_requests, :pulls
    end
  end
end
