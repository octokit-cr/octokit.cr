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
      alias Issue = Models::Issue

      # List issues for the authenticated user or repository
      #
      # **See Also:**
      # - https://developer.github.com/v3/issues/#list-issues-for-a-repository
      # - https://developer.github.com/v3/issues/#list-issues
      #
      # **Examples:**
      #
      # List issues for a repository
      # ```
      # Octokit.list_issues("watzon/cadmium")
      # ```
      #
      # List issues for the authenticated user across repositories
      # ```
      # @client = Octokit::Client.new(login: "foo", password: "bar")
      # @client.list_issues
      # ```
      def list_issues(repo = nil, **options)
        path = repo ? "#{Repository.path(repo)}/issues" : "issues"
        paginate Issue, path, options: {json: options}
      end
    end
  end
end
