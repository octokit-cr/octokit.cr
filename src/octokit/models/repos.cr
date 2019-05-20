module Octokit
  module Models
    class Repository
      # Created as a class to prevent recursive struct

      def slug
        Repository.slug(full_name)
      end

      def self.slug(repo)
        owner, name = repo.split('/')
        "#{owner}/#{name}"
      end

      def to_s(io)
        io << slug
      end

      def self.get_name(repo)
        repo.is_a?(String) ? name.split('/').last : repo.name
      end

      def self.get_full_name(repo)
        name = repo.is_a?(String) ? repo : repo.full_name
        parts = name.split('/')
        raise "The full name of a Repository must be in the format `user/repo`" unless parts.size > 1
        parts.join('/')
      end

      def self.path(repo)
        case repo
        when Int32
          "repositories/#{repo}"
        when String
          "repos/#{Repository.slug(repo)}"
        end
      end

      Octokit.rest_model(
        id: Int64,
        node_id: String,
        owner: RepositoryOwner,
        name: String,
        full_name: String,
        description: String?,
        homepage: String?,
        code_of_conduct: CodeOfConduct?,
        default_branch: String,
        master_branch: String?,
        created_at: String,
        pushed_at: String,
        updated_at: String,
        html_url: String,
        clone_url: String,
        git_url: String,
        mirror_url: String?,
        ssh_url: String,
        svn_url: String,
        language: String?,
        fork: Bool,
        forks_count: Int32,
        network_count: Int32?,
        open_issues_count: Int32,
        stargazers_count: Int32,
        subscribers_count: Int32?,
        watchers_count: Int32,
        size: Int32,
        auto_init: Bool?,
        parent: Repository?,
        source: Repository?,
        organization: Organization?,
        permissions: Hash(String, Bool),
        allow_rebase_merge: Bool?,
        allow_squash_merge: Bool?,
        allow_merge_commit: Bool?,
        topics: Array(String)?,
        archived: Bool,
        disabled: Bool,

        license: License?,

        private: Bool,
        has_issues: Bool,
        has_wiki: Bool,
        has_pages: Bool,
        has_projects: Bool,
        has_downloads: Bool,
        license_template: String?,
        gitignore_template: String?,

        team_id: Int64?,

        url: String,
        archive_url: String,
        assignees_url: String,
        blobs_url: String,
        branches_url: String,
        collaborators_url: String,
        comments_url: String,
        commits_url: String,
        compare_url: String,
        contents_url: String,
        contributors_url: String,
        deployments_url: String,
        downloads_url: String,
        events_url: String,
        forks_url: String,
        git_commits_url: String,
        git_refs_url: String,
        git_tags_url: String,
        hooks_url: String,
        issue_comment_url: String?,
        issue_events_url: String,
        issues_url: String,
        keys_url: String,
        labels_url: String,
        languages_url: String,
        merges_url: String,
        milestones_url: String,
        notifications_url: String,
        pulls_url: String,
        releases_url: String,
        stargazers_url: String,
        statuses_url: String,
        subscribers_url: String,
        subscription_url: String,
        tags_url: String,
        trees_url: String,
        teams_url: String,

        text_matches: Array(TextMatch)?
      )
    end

    struct RepositoryOwner
      Octokit.rest_model(
        login: String,
        id: Int64,
        node_id: String,
        avatar_url: String,
        gravatar_id: String,
        url: String,
        html_url: String,
        followers_url: String,
        following_url: String,
        gists_url: String,
        starred_url: String,
        subscriptions_url: String,
        organizations_url: String,
        repos_url: String,
        events_url: String,
        received_events_url: String,
        type: String,
        site_admin: Bool
      )
    end

    struct RepositoryDeployKey
      Octokit.rest_model(
        id: Int32,
        key: String,
        url: String,
        title: String,
        verified: Bool,
        created_at: String,
        read_only: Bool
      )
    end

    struct RepositoryListOptions
      Octokit.rest_model({
        visibility: String,

        affiliation: String,

        type: String,

        sort: String,

        direction: String,
        # }.merge(ListOptions::FIELDS))
      })
    end

    struct RepositoryListByOrgOptions
      Octokit.rest_model({
        type: String,
        # }.merge(ListOptions::FIELDS))
      })
    end

    struct RepositoryListAllOptions
      Octokit.rest_model(
        since: Int64
      )
    end

    struct CreateRepoRequest
      Octokit.rest_model(
        name: String?,
        description: String?,
        homepage: String?,

        private: Bool?,
        has_issues: Bool?,
        has_projects: Bool?,
        has_wiki: Bool?,
        default_branch: String?,

        team_id: Int64?,

        auto_init: Bool?,
        gitignore_template: String?,
        license_template: String?,
        allow_squash_merge: Bool?,
        allow_merge_commit: Bool?,
        allow_rebase_merge: Bool?
      )
    end

    struct Contributor
      Octokit.rest_model(
        login: String,
        id: Int64,
        avatar_url: String,
        gravatar_id: String,
        url: String,
        html_url: String,
        followers_url: String,
        following_url: String,
        gists_url: String,
        starred_url: String,
        subscriptions_url: String,
        organizations_url: String,
        repos_url: String,
        events_url: String,
        received_events_url: String,
        type: String,
        site_admin: Bool,
        contributions: Int32
      )
    end

    struct ListContributorsOptions
      Octokit.rest_model({
        anon: String,
        # }.merge(ListOptions::FIELDS))
      })
    end

    struct RepositoryTag
      Octokit.rest_model(
        name: String,
        commit: String,
        zipball_url: String,
        tarball_url: String
      )
    end

    struct Branch
      Octokit.rest_model(
        name: String,
        commit: RepositoryCommit,
        protected: Bool
      )
    end

    struct Protection
      Octokit.rest_model(
        required_status_checks: RequiredStatusChecks,
        required_pull_request_reviews: PullRequestReviewsEnforcement,
        enforce_admins: AdminEnforcement,
        restrictions: BranchRestrictions
      )
    end

    struct RequiredStatusChecks
      Octokit.rest_model(
        static: Bool,

        contexts: Array(String)
      )
    end

    struct RequiredStatusChecksRequest
      Octokit.rest_model(
        strict: Bool,
        contexts: Array(String)
      )
    end

    struct PullRequestReviewsEnforcement
      Octokit.rest_model(
        dismissal_restrictions: DismissalRestrictions,
        dismiss_stale_reviews: Bool,
        require_code_owner_reviews: Bool,
        required_approving_review_count: Int32
      )
    end

    struct PullRequestReviewsEnforcementRequest
      Octokit.rest_model(
        dismissal_restrictions_request: DismissalRestrictionsRequest,

        dismiss_stale_reviews: Bool,

        require_code_owner_reviews: Bool,

        required_approving_review_count: Int32
      )
    end

    struct PullRequestReviewsEnforcementUpdate
      Octokit.rest_model(
        dismissal_restrictions_request: DismissalRestrictionsRequest,

        dismiss_stale_reviews: Bool,

        require_code_owner_reviews: Bool,

        required_approving_review_count: Int32
      )
    end

    struct AdminEnforcement
      Octokit.rest_model(
        url: String,
        enabled: Bool
      )
    end

    struct BranchRestrictions
      Octokit.rest_model(
        users: Array(User),
        teams: Array(Team)
      )
    end

    struct BranchRestrictionsRequest
      Octokit.rest_model(
        users: Array(User)?,
        teams: Array(Team)?
      )
    end

    struct DismissalRestrictions
      Octokit.rest_model(
        users: Array(User),
        teams: Array(Team)
      )
    end

    struct DismissalRestrictionsRequest
      Octokit.rest_model(
        users: Array(User)?,
        teams: Array(Team)?
      )
    end

    struct SignaturesProtectedBranch
      Octokit.rest_model(
        url: String,
        enabled: Bool
      )
    end

    struct RepositoryTopics
      Octokit.rest_model(
        names: Array(String)
      )
    end

    struct TransferRequest
      Octokit.rest_model(
        new_owner: String,
        team_id: Array(Int64)
      )
    end
  end
end
