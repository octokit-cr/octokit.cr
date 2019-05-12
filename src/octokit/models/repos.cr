module Octokit
  module Models
    struct Repository
      rest_model(
        id: Int64,
        node_id: String,
        owner: User,
        name: String,
        full_name: String,
        description: String,
        homepage: String,
        code_of_conduct: CodeOfConduct,
        default_branch: String,
        master_branch: String,
        created_at: String,
        pushed_at: String,
        updated_at: String,
        html_url: String,
        clone_url: String,
        git_url: String,
        mirror_url: String,
        ssh_url: String,
        svn_url: String,
        language: String,
        fork: Bool,
        forks_count: Int32,
        network_count: Int32,
        open_issues_count: Int32,
        stargazers_count: Int32,
        subscribers_count: Int32,
        watchers_count: Int32,
        size: Int32,
        auto_init: Bool,
        parent: Repository,
        source: Repository,
        organization: Organization,
        permissions: Hash(String, Bool),
        allow_rebase_merge: Bool,
        allow_squash_merge: Bool,
        allow_merge_commit: Bool,
        topics: Array(String),
        archived: Bool,
        disabled: Bool,

        license: License,

        private: Bool,
        has_issues: Bool,
        has_wiki: Bool,
        has_pages: Bool,
        has_projects: Bool,
        has_downloads: Bool,
        license_template: String,
        gitignore_template: String,

        team_id: Int64,

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
        issue_comments_url: String,
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
        subscriptions_url: String,
        tags_url: String,
        trees_url: String,
        teams_url: String,

        text_matches: Array(TextMatch)
      )
    end

    struct RepositoryListOptions
      rest_model({
        visibility: String,

        affiliation: String,

        type: String,

        sort: String,

        direction: String
    }.merge(ListOptions::FIELDS))
    end

    struct RepositoryListByOrgOptions
      rest_model({
        type: String
    }.merge(ListOptions::FIELDS))
    end

    struct RepositoryListAllOptions
      rest_model(
        since: Int64
      )
    end

    struct CreateRepoRequest
      rest_model(
        name: String,
        description: String,
        homepage: String,

        private: Bool,
        has_issues: Bool,
        has_projects: Bool,
        has_wiki: Bool,

        team_id: Int64,

        auto_init: Bool,
        gitignore_template: String,
        license_template: String,
        allow_squash_merge: Bool,
        allow_merge_commit: Bool,
        allow_rebase_merge: Bool
      )
    end

    struct Contributor
      rest_model(
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
      rest_model({
        anon: String
    }.merge(ListOptions::FIELDS))
    end

    struct RepositoryTag
      name: String,
      commit: String,
      zipball_url: String,
      tarball_url: String
    end

    struct Branch
      rest_model(
        name: String,
        commit: RepositoryCommit,
        protected: Bool
      )
    end

    struct Protection
      rest_model(
        required_status_checks: RequiredStatusChecks,
        required_pull_request_reviews: PullRequestReviewsEnforcement,
        enforce_admins: AdminEnforcement,
        restrictions: BranchRestrictions
      )
    end

    struct RequiredStatusChecks
      rest_model(
        static: Bool,

        contexts: Array(String)
      )
    end

    struct RequiredStatusChecksRequest
      rest_model(
        strict: Bool,
        contexts: Array(String)
      )
    end

    struct PullRequestReviewsEnforcement
      rest_model(
        dismissal_restrictions: DismissalRestrictions,
        dismiss_stale_reviews: Bool,
        require_code_owner_reviews: Bool,
        required_approving_review_count: Int32
      )
    end

    struct PullRequestReviewsEnforcementRequest
      rest_model(
        dismissal_restrictions_request: DismissalRestrictionsRequest,

        dismiss_stale_reviews: Bool,

        require_code_owner_reviews: Bool,

        required_approving_review_count: Int32
      )
    end

    struct PullRequestReviewsEnforcementUpdate
      rest_model(
        dismissal_restrictions_request: DismissalRestrictionsRequest,
        
        dismiss_stale_reviews: Bool,

        require_code_owner_reviews: Bool,

        required_approving_review_count: Int32
      )
    end

    struct AdminEnforcement
      rest_model(
        url: String,
        enabled: Bool
      )
    end

    struct BranchRestrictions
      rest_model(
        users: Array(User),
        teams: Array(Team)
      )
    end

    struct BranchRestrictionsRequest
      rest_model(
        users: Array(User)?,
        teams: Array(Team)?
      )
    end

    struct DismissalRestrictions
      rest_model(
        users: Array(User),
        teams: Array(Team)
      )
    end

    struct DismissalRestrictionsRequest
      rest_model(
        users: Array(User)?,
        teams: Array(Team)?
      )
    end

    struct SignaturesProtectedBranch
      rest_model(
        url: String,
        enabled: Bool
      )
    end

    struct RepositoryTopics
      rest_model(
        names: Array(String)
      )
    end

    struct TransferRequest
      rest_model(
        new_owner: String,
        team_id: Array(Int64)
      )
    end
  end
end
