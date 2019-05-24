module Octokit
  class Client
    # Methods for the Repositories API
    #
    # **See Also:**
    # - [https://developer.github.com/v3/repos/](https://developer.github.com/v3/repos/)
    module Repositories
      # :nodoc:
      alias Repository = Models::Repository

      # Check if a repository exists.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/#get](https://developer.github.com/v3/repos/#get)
      def repository?(repo)
        !!repository(repo)
      rescue Octokit::Error::InvalidRepository
        false
      rescue Octokit::Error::NotFound
        false
      end

      # Get a single repository
      #
      # **Aliases:** `repo`
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/#get](https://developer.github.com/v3/repos/#get)
      # - [https://developer.github.com/v3/licenses/#get-a-repositorys-license](https://developer.github.com/v3/licenses/#get-a-repositorys-license)
      def repository(path)
        res = get Repository.path(path)
        Repository.from_json(res)
      end

      alias_method :repository, :repo

      # Edit a repository.
      #
      # **Example:**
      # ```
      # @client.edit_repository("watzon/cadmium", has_wiki: true)
      # ```
      #
      # Available edit options are stored in `Octokit::Models::CreateRepoRequest`
      #
      # **Aliases:** `edit`, `update`, `update`
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/#edit](https://developer.github.com/v3/repos/#edit)
      def edit_repository(repo : String | Repository, **options)
        name = Repository.get_name(repo)
        options = {name: name}.merge(options)
        res = post "repos/#{repo}", {json: options}
        Repository.from_json(res)
      end

      alias_method :edit_repository, :edit
      alias_method :edit_repository, :update_repository
      alias_method :edit_repository, :update

      # List user repositories.
      #
      # If user is not supplied, repositories for the current
      # authenticated user are returned.
      #
      # **Aliases:** `list_repositories`, `list_repos`, `repos`
      #
      # **Note:** If the user provided is a GitHub organization, only the
      #   organization's public repositories will be listed. For retrieving
      #   organization repositories the `Organizations#organization_repositories`
      #   method should be used instead.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/#list-your-repositories](https://developer.github.com/v3/repos/#list-your-repositories)
      # - [https://developer.github.com/v3/repos/#list-user-repositories](https://developer.github.com/v3/repos/#list-user-repositories)
      def repositories(user = nil, **options)
        paginate Repository, "#{User.path user}/repos", **options
      end

      alias_method :edit_repository, :list_repositories
      alias_method :edit_repository, :list_repos
      alias_method :edit_repository, :repos

      # List all repositories.
      #
      # This provides a dump of every public repository on Github, in the order
      # that they were created.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/#list-all-public-repositories](https://developer.github.com/v3/repos/#list-all-public-repositories)
      def all_repositories(**options)
        paginate Repository, "repositories", **options
      end

      # Star a repository.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/activity/starring/#star-a-repository](https://developer.github.com/v3/activity/starring/#star-a-repository)
      def star(repo)
        boolean_from_response :put, "user/starred/#{Repository.get_full_name(repo)}"
      end

      # Unstar a repository.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/activity/starring/#unstar-a-repository](https://developer.github.com/v3/activity/starring/#unstar-a-repository)
      def unstar(repo)
        boolean_from_response :delete, "user/starred/#{Repository.get_full_name(repo)}"
      end

      # Watch a repository.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/activity/watching/#watch-a-repository-legacy](https://developer.github.com/v3/activity/watching/#watch-a-repository-legacy)
      def watch(repo)
        boolean_from_response :put, "user/watched/#{Repository.get_full_name(repo)}"
      end

      # Unwatch a repository.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/activity/watching/#stop-watching-a-repository-legacy](https://developer.github.com/v3/activity/watching/#stop-watching-a-repository-legacy)
      def unwatch(repo)
        boolean_from_response :put, "user/watched/#{Repository.get_full_name(repo)}"
      end

      # Fork a repository.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/forks/#create-a-fork](https://developer.github.com/v3/repos/forks/#create-a-fork)
      def fork(repo)
        post "#{Repository.path(repo)}/forks"
      end

      # Create a repository for a user or organization.
      #
      # **Aliases:** `create`, `create_repo`
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/#create](https://developer.github.com/v3/repos/#create)
      def create_repository(repo, organization = nil, **options)
        name = Repository.get_name(repo)
        options = {name: name}.merge(options)

        if organization.nil?
          res = post "user/repos", {json: options}
        else
          res = post "#{Octokit::Models::Organization.path(organization)}/repos", {json: options}
        end

        Repository.from_json(res)
      end

      alias_method :create_repository, :create_repo
      alias_method :create_repository, :create

      # Delete a repository.
      #
      # **Aliases:** `delete_repo`
      #
      # **Note:** If OAuth is used, 'delete_repo' scope is required.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/#delete-a-repository](https://developer.github.com/v3/repos/#delete-a-repository)
      def delete_repository(repo)
        boolean_from_response :delete, Repository.path(repo)
      end

      # Transfer a repository.
      #
      # Transfer a repository owned by your organization.
      #
      # **Aliases:** `transfer_repo`
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/#transfer-a-repository](https://developer.github.com/v3/repos/#transfer-a-repository)
      def transfer_repository(repo, new_owner, team_ids : Array(Int32))
        options = {new_owner: new_owner, team_ids: team_ids}
        res = post "#{Repository.path(repo)}/transfer", {json: options}
        Repository.from_json(res)
      end

      alias_method :transfer_repository, :transfer_repo

      # Hide a public repository.
      #
      # This is a convenience method that uses `#update_repository`
      def set_private(repo)
        update_repository repo, {private: true}
      end

      # Unhide a private repository.
      #
      # This is a convenience method that uses `#update_repository`
      def set_public(repo)
        update_repository repo, {private: false}
      end

      # Get deploy keys on a repo.
      #
      # Requires authenticated client.
      #
      # **Aliases:**
      # - [https://developer.github.com/v3/repos/keys/#list-deploy-keys](https://developer.github.com/v3/repos/keys/#list-deploy-keys)
      #
      # **Example:**
      # ```
      # @client.deploy_keys("watzon/cadmium")
      # ```
      def deploy_keys(repo)
        paginate Repository, "#{Repository.path(repo)}/keys"
      end

      alias_method :deploy_keys, :list_deploy_keys

      # Get a single deploy key for a repo.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/keys/#get-a-deploy-key](https://developer.github.com/v3/repos/keys/#get-a-deploy-key)
      #
      # **Example:**
      # ```
      # @client.deploy_key("watzon/cadmium", 7729435)
      # ```
      def deploy_key(repo, id)
        res = get "#{Repository.path(repo)}/keys/#{id}"
        RepositoryDeployKey.from_json(res)
      end

      # Add deploy key to a repo.
      #
      # Requires authenticated client.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/keys/#add-a-new-deploy-key](https://developer.github.com/v3/repos/keys/#add-a-new-deploy-key)
      #
      # **Example:**
      # ```
      # @client.deploy_key("watzon/cadmium", "Staging server", "ssh-rsa AAA...")
      # ```
      def add_deploy_key(repo, title, key, read_only = false)
        options = {title: title, key: key, read_only: read_only}
        res = post "#{Repository.path(repo)}/keys", {json: options}
        RepositoryDeployKey.from_json(res)
      end

      # Remove a deploy key from a repo.
      #
      # **Note:** Requires authenticated client.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/keys/#remove-a-deploy-key](https://developer.github.com/v3/repos/keys/#remove-a-deploy-key)
      #
      # **Example:**
      # ```
      # @client.remove_deploy_key("watzon/cadmium", 7729435)
      # ```
      def remove_deploy_key(repo, id)
        boolean_from_response :delete, "#{Repository.path(repo)}/keys/#{id}"
      end

      # List collaborators.
      #
      # **Aliases:** `collabs`
      #
      # **Note:** Requires authenticated client for private repos.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/collaborators/#list-collaborators](https://developer.github.com/v3/repos/collaborators/#list-collaborators)
      #
      # **Examples:**
      #
      # With unauthenticated client
      # ```
      # Octokit.client.collaborators("watzon/cadmium")
      # ```
      #
      # With authenticated client
      # ```
      # @client.collaborators("watzon/cadmium")
      # ```
      def collaborators(repo, affiliation = :all)
        options = {affiliation: affiliation.to_s}
        paginate User, "#{Repository.path(repo)}/collaborators", options: {json: options}
      end

      alias_method :collaborators, :collabs

      # Add collaborator to a repo.
      #
      # This can be used to update the permissions of an existing collaborator.
      #
      # **Aliases:** `add_collab`
      #
      # **Note:** Requires authenticated client.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/collaborators/#add-user-as-a-collaborator](https://developer.github.com/v3/repos/collaborators/#add-user-as-a-collaborator)
      #
      # **Examples:**
      #
      # Add a new collaborator
      # ```
      # @client.add_collaborator("watzon/cadmium", "asterite")
      # ```
      #
      # Update permissions for a collaborator
      # ```
      # @client.add_collaborator("watzon/cadmium", "asterite", permisson: "admin")
      # ```
      def add_collaborator(repo, collaborator, **options)
        boolean_from_response :put, "#{Repository.path(repo)}/collaborators/#{collaborator}", {json: options}
      end

      alias_method :add_collaborator, :add_collab

      # Remove collaborator from a repo.
      #
      # **Aliases:** `remove_collab`
      #
      # **Note:** Requires authenticated client.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/collaborators/#remove-user-as-a-collaborator](https://developer.github.com/v3/repos/collaborators/#remove-user-as-a-collaborator)
      #
      # **Example:**
      # ```
      # @client.remove_collaborator("watzon/cadmium", "asterite")
      # ```
      def remove_collaborator(repo, collaborator)
        boolean_from_response :delete, "#{Repository.path(repo)}/collaborators/#{collaborator}"
      end

      alias_method :remove_collaborator, :remove_collab

      # Check if a user is a collaborator for a repo
      #
      # **Note:** Requires authenticated client.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/collaborators/#check-if-a-user-is-a-collaborator](https://developer.github.com/v3/repos/collaborators/#check-if-a-user-is-a-collaborator)
      #
      # **Example:**
      # ```
      # @client.collaborator?("watzon/cadmium", "asterite")
      # ```
      def collaborator?(repo, collaborator)
        boolean_from_response :get, "#{Repository.path(repo)}/collaborators/#{collaborator}"
      end

      # Get a user's permission level for a repo.
      #
      # **Note:** Requires authenticated client.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/collaborators/#review-a-users-permission-level](https://developer.github.com/v3/repos/collaborators/#review-a-users-permission-level)
      #
      # **Example:**
      # ```
      # @client.permission_level("watzon/cadmium", "asterite")
      # ```
      def permission_level(repo, collaborator)
        res = get "#{Repository.path(repo)}/collaborators/#{collaborator}/permission"
        Models::RepositoryPermissionLevel.from_json(res)
      end

      # List teams for a repo.
      #
      # **Aliases:** `repo_teams`, `teams`
      #
      # **Note:** Requires authenticated client that is an owner or collaborator of the repo.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/#list-teams](https://developer.github.com/v3/repos/#list-teams)
      #
      # **Example:**
      # ```
      # @client.repository_teams("watzon/cadmium")
      # ```
      def repository_teams(repo)
        paginate Team, "#{Repository.path(repo)}/teams"
      end

      alias_method :repository_teams, :repo_teams
      alias_method :repository_teams, :teams

      # List all topics for a repository.
      #
      # **Note:** Requires authenticated client that is an owner or collaborator of the repo.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/#list-all-topics-for-a-repository](https://developer.github.com/v3/repos/#list-all-topics-for-a-repository)
      #
      # **Example:**
      # ```
      # @client.topics("watzon/cadmium")
      # ```
      def topics(repo)
        headers = api_media_type(:topics)
        paginate Models::RepositoryTopics, "#{Repository.path(repo)}/topics", options: {headers: headers}
      end

      # Replace all topics for a repository.
      #
      # **Note:** Requires authenticated client.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/#replace-all-topics-for-a-repository](https://developer.github.com/v3/repos/#replace-all-topics-for-a-repository)
      #
      # **Examples:**
      #
      # Replace all topics
      # ```
      # @client.replace_all_topics("watzon/cadmium", ["element", "nlp", "crystal", "awesome"])
      # ```
      #
      # Clear all topics
      # ```
      # @client.replace_all_topics("watzon/cadmium", nil)
      # ```
      def replace_all_topics(repo, names)
        json = {names: names || [] of String}
        options = {headers: api_media_type(:topics), json: json}
        res = put "#{Repository.path(repo)}/topics", options: options
        Models::RepositoryTopics.from_json(res)
      end

      # List contributors to a repo.
      #
      # **Aliases:** `contribs`
      #
      # **Note:** Requires authenticated client for private repos.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/#list-contributors](https://developer.github.com/v3/repos/#list-contributors)
      #
      # **Examples:**
      # ```
      # Octokit.client.contributors("watzon/cadmium", true)
      # @client.contribs("watzon/cadmium")
      # ```
      def contributors(repo, anon = false)
        paginate User, "#{Repository.path(repo)}/contributors", options: {json: {anon: anon}}
      end

      alias_method :contributors, :contribs

      # List stargazers of a repo.
      #
      # **Note:** Requires authenticated client for private repos.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/activity/starring/#list-stargazers](https://developer.github.com/v3/activity/starring/#list-stargazers)
      #
      # **Examples:**
      # ```
      # Octokit.client.stargazers("watzon/cadmium")
      # @client.stargazers("watzon/cadmium")
      # ```
      def stargazers(repo)
        paginate User, "#{Repository.path(repo)}/stargazers"
      end

      # List forks
      #
      # **Aliases:** `network`
      #
      # **Note:** Requires authenticated client for private repos.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/forks/#list-forks](https://developer.github.com/v3/repos/forks/#list-forks)
      #
      # **Examples:**
      # ```
      # Octokit.client.forks("watzon/cadmium")
      # @client.forks("watzon/cadmium", sort: "oldest")
      # ```
      def forks(repo, sort = "newest")
        paginate Repository, "#{Repository.path(repo)}/forks", options: {json: {sort: sort}}
      end

      alias_method :forks, :network

      # List programming languages in the repo.
      #
      # **Note:** Requires authenticated client for private repos.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/#list-languages](https://developer.github.com/v3/repos/#list-languages)
      #
      # **Examples:**
      # ```
      # Octokit.client.languages("watzon/cadmium")
      # @client.languages("watzon/cadmium", sort: "oldest")
      # ```
      def languages(repo)
        paginate Hash(String, Int32), "#{Repository.path(repo)}/languages"
      end

      # List tags
      #
      # **Note:** Requires authenticated client for private repos.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/#list-tags](https://developer.github.com/v3/repos/#list-tags)
      #
      # **Examples:**
      # ```
      # Octokit.client.tags("watzon/cadmium")
      # @client.tags("watzon/cadmium")
      # ```
      def tags(repo)
        paginate RepositoryTag, "#{Repository.path(repo)}/tags"
      end

      # List branches
      #
      # **Note:** Requires authenticated client for private repos.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/branches/#list-branches](https://developer.github.com/v3/repos/branches/#list-branches)
      #
      # **Examples:**
      # ```
      # Octokit.client.branches("watzon/cadmium")
      # @client.branches("watzon/cadmium")
      # ```
      def branches(repo, get_protected = false)
        paginate Models::Branch, "#{Repository.path(repo)}/branches", options: {json: {protected: get_protected}}
      end

      # Get a single branch from a repository.
      #
      # **Aliases:** `get_branch`
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/branches/#get-branch](https://developer.github.com/v3/repos/branches/#get-branch)
      #
      # **Example:**
      # ```
      # Octokit.client.branch("watzon/cadmium", "master")
      # ```
      def branch(repo, branch)
        res = get "#{Repository.path(repo)}/branches/#{branch}"
        Models::Branch.from_json(res)
      end

      alias_method :branch, :get_branch

      # Lock a single branch from a repository.
      #
      # **Note:** Requires authenticated client
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/branches/#get-branch](https://developer.github.com/v3/repos/branches/#get-branch)
      #
      # **Example:**
      # ```
      # @client.protect_branch("watzon/cadmium", "master")
      # ```
      def protect_branch(repo, branch, **options)
        headers = api_media_type(:branch_protection)
        options = options.merge({
          restrictions:           nil,
          required_status_checks: nil,
        })
        opts = {headers: headers, json: options}
        res = put "#{Repository.path(repo)}/branches/#{branch}/protection", opts
        Models::BranchProtectionSummary.from_json(res)
      end

      # Get branch protection summary.
      #
      # **Note:** Requires authenticated client
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/branches/#get-branch-protection](https://developer.github.com/v3/repos/branches/#get-branch-protection)
      #
      # **Example:**
      # ```
      # @client.branch_protection("watzon/cadmium", "master")
      # ```
      def branch_protection(repo, branch)
        headers = api_media_type(:branch_protection)
        begin
          res = get "#{Repository.path(repo)}/branches/#{branch}/protection", {headers: headers}
          Models::BranchProtectionSummary.from_json(res.body)
        rescue Octokit::BranchNotProtected
          nil
        end
      end

      # Unlock a single branch from a repository.
      #
      # **Note:** Requires authenticated client
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/#enabling-and-disabling-branch-protection](https://developer.github.com/v3/repos/#enabling-and-disabling-branch-protection)
      #
      # **Example:**
      # ```
      # @client.unprotect_branch("watzon/cadmium", "master")
      # ```
      def unprotect_branch(repo, branch)
        headers = api_media_type(:branch_protection)
        boolean_from_response :delete, "#{Repository.path(repo)}/branches/#{branch}/protection", {headers: headers}
      end

      # List users available for assigning issues.
      #
      # **Aliases:** `repo_assignees`
      #
      # **Note:** Requires authenticated client for private repos.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/assignees/#list-assignees](https://developer.github.com/v3/issues/assignees/#list-assignees)
      #
      # **Examples:**
      # ```
      # Octokit.client.repository_assignees("watzon/cadmium")
      # @client.repository_assignees("watzon/cadmium")
      # ```
      def repository_assignees(repo)
        paginate User, "#{Repository.path(repo)}/assignees"
      end

      alias_method :repository_assignees, :repo_assignees

      # Check to see if a particular user is an assignee for a repository.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/issues/assignees/#check-assignee](https://developer.github.com/v3/issues/assignees/#check-assignee)
      #
      # **Example:**
      # ```
      # Octokit.client.repository_assignees("watzon/cadmium")
      # ```
      def check_assignee(repo, assignee)
        boolean_from_response :get, "#{Repository.path(repo)}/assignees/#{assignee}"
      end

      # List watchers subscribing to notifications for a repo.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/activity/watching/#list-watchers](https://developer.github.com/v3/activity/watching/#list-watchers)
      #
      # **Example:**
      # ```
      # @client.subscribers("watzon/cadmium")
      # ```
      def subscribers(repo)
        paginate User, "#{Repository.path(repo)}/subscribers"
      end

      # Get a repository subscription.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/activity/watching/#get-a-repository-subscription](https://developer.github.com/v3/activity/watching/#get-a-repository-subscription)
      #
      # **Example:**
      # ```
      # @client.subscription("watzon/cadmium")
      # ```
      def subscription(repo)
        res = get "#{Repository.path(repo)}/subscription"
        Models::Subscription.from_json(res.body)
      end

      # Update a repository subscription.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/activity/watching/#set-a-repository-subscription](https://developer.github.com/v3/activity/watching/#set-a-repository-subscription)
      #
      # **Example:**
      # ```
      # @client.update_subscription("watzon/cadmium", subscribed: true)
      # ```
      def update_subscription(repo, **options)
        res = put "#{Repository.path(repo)}/subscription", {json: options}
        Models::Subscription.from_json(res.body)
      end

      # Delete a repository subscription.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/activity/watching/#delete-a-repository-subscription](https://developer.github.com/v3/activity/watching/#delete-a-repository-subscription)
      #
      # **Example:**
      # ```
      # @client.delete_subscription("watzon/cadmium")
      # ```
      def delete_subscription(repo, **options)
        boolean_from_response :delete, "#{Repository.path(repo)}/subscription", {json: options}
      end
    end
  end
end
