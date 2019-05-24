module Octokit
  class Client
    # Methods for the Search API
    #
    # Valid options for all search methods are as follows:
    # - `sort` - sort field
    # - `order` - sort order (`:asc` or `:dsc`)
    # - `page` - the page to return
    # - `per_page` - number of items per page
    #
    # **See Also:**
    # - [https://developer.github.com/v3/search/](https://developer.github.com/v3/search/)
    module Search
      # Search code
      #
      # **See Also:**
      # - [https://developer.github.com/v3/search/#search-code](https://developer.github.com/v3/search/#search-code)
      def search_code(query, **options) : Paginator(Models::CodeSearchResult)
        search Models::CodeSearchResult, "search/code", query, options
      end

      # Search commits
      #
      # **See Also:**
      # - [https://developer.github.com/v3/search/#search-commits](https://developer.github.com/v3/search/#search-commits)
      def search_commits(query, **options) : Paginator(Models::CommitsSearchResult)
        options = ensure_api_media_type(:commit_search, options)
        search Models::CommitsSearchResult, "search/commits", query, options
      end

      # Search issues
      #
      # **See Also:**
      # - [https://developer.github.com/v3/search/#search-issues](https://developer.github.com/v3/search/#search-issues)
      def search_issues(query, **options) : Paginator(Models::IssuesSearchResult)
        search Models::IssuesSearchResult, "search/issues", query, options
      end

      # Search repositories
      #
      # **Aliases:** `search_repos`
      #
      # **See Also:**
      # - [https://developer.github.com/v3/search/#search-repositories](https://developer.github.com/v3/search/#search-repositories)
      def search_repositories(query, **options) : Paginator(Models::RepositoriesSearchResult)
        search Models::RepositoriesSearchResult, "search/repositories", query, options
      end

      alias_method :search_repositories, :search_repos

      # Search users
      #
      # **See Also:**
      # - [https://developer.github.com/v3/search/#search-users](https://developer.github.com/v3/search/#search-users)
      def search_users(query, **options) : Paginator(Models::UsersSearchResult)
        search Models::UsersSearchResult, "search/users", query, options
      end

      private def search(klass, path, query, options)
        paginate(
          klass,
          path,
          start_page: options[:page]?,
          per_page: options[:per_page]?,
          options: {
            params: {
              q:     query,
              sort:  options[:sort]?,
              order: options[:order]?,
            },
          }
        )
      end
    end
  end
end
