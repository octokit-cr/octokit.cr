module Octokit
  class Client
    # Methods for the Commit Statuses API
    #
    # **See Also:**
    # - [https://developer.github.com/v3/repos/statuses/](https://developer.github.com/v3/repos/statuses/)
    module Statuses
      # :nodoc:
      alias RepoStatus = Models::RepoStatus

      # :nodoc:
      alias CombinedStatus = Models::CombinedStatus

      # List all statuses for a given commit.
      #
      # **See All:**
      # - [https://developer.github.com/v3/repos/statuses/#list-statuses-for-a-specific-ref](https://developer.github.com/v3/repos/statuses/#list-statuses-for-a-specific-ref)
      def statuses(repo, sha)
        paginate RepoStatus, "#{Repository.path(repo)}/statuses/#{sha}"
      end

      alias_method :statuses, :list_statuses

      # Get the combined status for a ref.
      #
      # **See All:**
      # - [https://developer.github.com/v3/repos/statuses/#get-the-combined-status-for-a-specific-ref](https://developer.github.com/v3/repos/statuses/#get-the-combined-status-for-a-specific-ref)
      def combined_status(repo, ref)
        res = get "#{Repository.path(repo)}/commits/#{ref}/status"
        CombinedStatus.from_json(res)
      end

      alias_method :combined_status, :status

      # Create a status for a commit.
      #
      # **See All:**
      # - [https://developer.github.com/v3/repos/statuses/#create-a-status](https://developer.github.com/v3/repos/statuses/#create-a-status)
      def create_status(repo, sha, state, **options)
        options = options.merge(state: state)
        res = post "#{Repository.path(repo)}/commits/#{ref}/status", {json: options}
        RepoStatus.from_json(res)
      end
    end
  end
end
