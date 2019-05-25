module Octokit
  class Client
    # Methods for the Releases API
    #
    # **See Also:**
    # - [https://developer.github.com/v3/repos/releases/](https://developer.github.com/v3/repos/releases/)
    class Releases
      # :nodoc:
      alias Repository = Models::Repository

      # :nodoc:
      alias RepositoryRelease = Models::RepositoryRelease

      # :nodoc:
      alias ReleaseAsset = Models::ReleaseAsset

      # List releases for a repository.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/releases/#list-releases-for-a-repository](https://developer.github.com/v3/repos/releases/#list-releases-for-a-repository)
      def releases(repo)
        paginate
      end
    end
  end
end
