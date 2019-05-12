module Octokit
  module Models
    struct RequestedAction
      rest_model(
        identifier: String
      )
    end

    struct CheckRunEvent
      rest_model(
        check_run: CheckRun,
        
        # The action performed. Possible values are: "created", "updated", "rerequested", or "requested_action".
        action: String,

        # The following fields are only published by Webhook events.
        repo: { key: "repository", type: Repository? },
        org: { key: "organization", type: Organization? },
        sender: User?,
        installation: Installation?,

        # The action requested by the user. Populated when the `action` is "requested_action".
        requested_action: RequestedAction?
      )
    end

    struct CheckSuiteEvent
      rest_model(
        check_suite: CheckSuite,

        # The action performed. Possible values are: "completed", "requested" or "rerequested".
        action: String,

        # The following fields are only populated by Webhook events.
        repo: { key: "repository", type: Repository? },
        org: { key: "organization", type: Organization? },
        sender: User?,
        installation: Installation?
      )
    end

    struct CommitCommentEvent
      rest_model(
        comment: RepositoryComment,

        # The following fields are only populated by Webhook events.
        action: String?,
        repo: { key: "repository", type: Repository? },
        sender: User?,
        installation: Installation?
      )
    end

    struct CreateEvent
      rest_model(
        ref: String,

        # `ref_type` is the object that was created. Possible values are: "repository", "branch", "tag".
        ref_type: String,

        master_branch: String,
        description: String,

        # The following fields are only populated by Webhook events.
        pusher_type: String?,
        repo: { key: "repository", type: Repository? },
        sender: User?,
        installation: Installation?
      )
    end

    struct DeleteEvent
      rest_model(
        ref: String,

        # `ref_type` is the object that was deleted. Possible values are: "branch:, "tag".
        ref_type: String,

        # The following fields are only populated by Webhook events.
        pusher_type: String?,
        repo: { key: "repository", type: Repository? },
        sender: User?,
        installation: Installation?
      )
    end

    struct DeployKeyEvent
      rest_model(
        # `action` is the action that was performed. Possible values are: "created" or "deleted".
        action: String,

        # The deploy key resource.
        key: Key
      )
    end

    struct DeploymentEvent
      rest_model(
        deployment: Deployment,
        deployment_status: DeploymentStatus,
        repo: { key: "repository", type: Repository },

        # The following fields are only populated by Webhook events.
        sender: User?,
        installation: Installation?
      )
    end

    struct DeploymentStatusEvent
      rest_model(
        deployment: Deployment,
        deployment_status: DeploymentStatus,
        repo: { key: "repository", type: Repository },

        # The following fields are only populated by Webhook events.
        sender: User?,
        installation: Installation?
      )
    end

    struct ForkEvent
      rest_model(
        # The forkee is the created repository.
        forkee: Repository,

        # The following fields are only populated by Webhook events.
        repo: { key: "repository", type: Repository? },
        sender: User?,
        installation: Installation?
      )
    end

    struct GitHubAppAuthorizationEvent
      rest_model(
        # The action performed. Possible value is: "revoked".
        action: String,

        # The following fields are only populated by Webhook events.
        sender: User?
      )
    end

    struct Page
      rest_model(
        page_name: String,
        title: String,
        summary: String,
        action: String,
        sha: String,
        html_url: String
      )
    end

    struct GollumEvent
      rest_model(
        pages: Array(Page),

        # The following fields are only populated by Webhook events.
        repo: { key: "repository", type: Repository? },
        sender: User?,
        installation: Installation?
      )
    end

    struct EditChange
      rest_model(
        title: NamedTuple(from: String),
        body: NamedTuple(body: String)
      )
    end

    struct ProjectChange
      rest_model(
        title: NamedTuple(from: String),
        body: NamedTuple(body: String)
      )
    end

    struct ProductChange
      rest_model(
        note: NamedTuple(from: String)
      )
    end

    struct ProductCardChange
      rest_model(
        note: NamedTuple(from: String)
      )
    end

    struct ProductColumnChange
      rest_model(
        note: NamedTuple(from: String)
      )
    end

    struct TeamChange
      rest_model(
        description: NamedTuple(from: String),
        name: NamedTuple(from: String),
        privacy: NamedTuple(from: String),
        repository: NamedTuple(permissions: TeamChange::From)
      )

      struct From
        rest_model(
          admin: Bool,
          pull: Bool,
          push: Bool
        )
      end
    end

    struct InstallationEvent
      rest_model(
        # The action that was performed. Can be either "created" or "deleted".
        action: String,

        repositories: Array(Repository),
        sender: User,
        installation: Installation
      )
    end

    struct InstallationRepositoriesEvent
      rest_model(
        # The action that was performed. Can be either "added" or "removed".
        action: String,

        repositories_added: Array(String),
        repositories_removed: Array(String),
        repository_selection: String,
        sender: User,
        installation: Installation
      )
    end

    struct IssueCommentEvent
      rest_model(
        # The action that was performed on the comment. Can be either "created", "edited" or "deleted".
        action: String,
        issue: Issue,
        comment: IssueComment,

        # The following fields are only populated by Webhook events.
        changes: EditChange?,
        repo: { key: "repository", type: Repository? },
        sender: User?,
        installation: Installation?
      )
    end

    struct IssuesEvent
      rest_model(
        # Action is the action that was performed. Possible values are: "opened",
        # "edited", "deleted", "transferred", "pinned", "unpinned", "closed", "reopened",
        # "assigned", "unassigned", "labeled", "unlabeled", "locked", "unlocked",
        # "milestoned", or "demilestoned".
        action: String,

        issue: Issue,
        assignee: User,
        label: Label,

        # The following fields are only populated by Webhook events.
        changes: EditChange?,
        repo: Repository?,
        sender: User?,
        installation: Installation?
      )
    end

    struct LabelEvent
      rest_model(
        # Action that was performed. Possible values are: "created", "edited" or "deleted".
        action: String,
        label: Label,

        # The following fields are only populated by Webhook events.
        changes: EditChange?,
        repo: { key: "repository", type: Repository? },
        org: { key: "organization", type: Organization? },
        installation: Installation?
      )
    end

    struct MarketplacePurchaseEvent
      rest_model(
        # Action is the action that was performed. Possible values are:
        # "purchased", "cancelled", "pending_change", "pending_change_cancelled", "changed".
        action: String,

        # The following fields are only populated by Webhook events.
        effective_date: String?,
        marketplace_purchase: MarketplacePurchase?,
        previous_marketplace_purchase: MarketplacePurchase?,
        sender: User?,
        installation: Installation?
      )
    end

    struct MemberEvent
      rest_model(
        # `action` that was performed. Possible value is: "added".
        action: String,
        member: User,

        # The following fields are only populated by Webhook events.
        repo: { key: "repository", type: Repository? },
        sender: User?,
        installation: Installation?
      )
    end

    struct MemberEvent
      action: String,

      repo: { key: "repository", type: Repository? },
      sender: User,
      installation: Installation?
    end

    struct MembershipEvent
      rest_model(
        action: String,

        scope: String,
        member: String,
        team: String,

        org: { key: "organization", type: Organization? },
        sender: User,
        installation: Installation?
      )
    end

    struct MetaEvent
      rest_model(
        action: String,

        hook_id: Int64,

        hook: Hook
      )
    end

    struct MilestoneEvent
      rest_model(
        action: String,
        milestone: Milestone,

        changes: EditChange?,
        repo: { key: "repository", type: Repository? },
        sender: User?,
        org: { key: "organization", type: Organization? },
        installation: Installation?
      )
    end

    struct OrganizationEvent
      rest_model(
        action: String,

        invitation: Invitation?,

        membership: Membership?,

        organization: Organization?,
        sender: User?,
        installation: Installation?
      )
    end

    struct OrgBlockEvent
      rest_model(
        action: String,
        blocked_user: User,
        organization: Organization,
        sender: User,

        installation: Installation?
      )
    end

    struct PageBuildEvent
       rest_model(
        build: PagesBuild,

        id: Int64?,
        repo: { key: "repository", type: Repository? },
        sender: User?,
        installation: Installation?
       )
    end

    struct PingEvent
      rest_model(
        zen: String,
        hook_id: Int64,
        hook: Hook,
        installation: Installation
      )
    end

    struct ProjectEvent
      rest_model(
        action: String,
        changes: ProjectChange,
        project: Project,

        repo: { key: "repository", type: Repository? },
        org: { key: "organization", type: Organization? },
        sender: User?,
        installation: Installation?
      )
    end

    stuct ProjcetCardEvent
      rest_model(
        action: String,
        changes: ProjectCardChange,
        after_id: Int64,
        project_card: ProjectCard,

        repo: { key: "repository", type: Repository? },
        org: { key: "organization", type: Organization? },
        sender: User?,
        installation: Installation?
      )
    end

    struct ProjectColumnEvent
      rest_model(
        action: String,
        changes: ProjectColumnChange,
        after_id: Int64,
        project_column: ProjectColumn,

        repo: { key: "repository", type: Repository? },
        org: { key: "organization", type: Organization? },
        sender: User?,
        installation: Installation?
      )
    end

    struct PublicEvent
      rest_model(
        repo: { key: "repository", type: Repository? },
        sender: User,
        installation: Installation
      )
    end

    struct PullRequestEvent
      rest_model(
        action: String,
        assignee: User,
        number: Int32,
        pull_request: PullRequest,

        changes: EditChange?,

        requested_reviewer: User?,
        repo: { key: "repository", type: Repository? },
        sender: User?,
        installation: Installation?,
        label: Label?,

        organization: Organization?
      )
    end

    struct PullRequestReviewEvent
      rest_model(
        action: String,
        review: PullRequestReview,
        pull_request: PullRequest,

        repo: { key: "repository", type: Repository? },
        sender: User?,
        installation: Installation?,

        organization: Organization?
      )
    end

    struct PullRequestReviewCommentEvent
      rest_model(
        action: String,
        pull_request: PullRequest,
        comment: PullRequestComment,

        changes: EditChange?,
        repo: { key: "repository", type: Repository? },
        sender: User?,
        installation: Installation?
      )
    end

    struct PushEvent
      rest_model(
        push_id: Int64,
        head: String,
        ref: String,
        size: Int32,
        commits: Array(PushEventCommit),
        before: String,
        distinct_size: Int32,

        after: String?,
        created: Bool?,
        deleted: Bool?,
        forced: Bool?,
        base_ref: String?,
        compare: String?,
        repo: { key: "repository", type: PushEventRepository? },
        head_commit: PushEventCommit?,
        pusher: User?,
        sender: User?,
        installation: Installation?
      )
    end

    struct PushEventCommit
      rest_model(
        message: String,
        author: CommitAuthor,
        url: String,
        distinct: Bool,

        sha: String?,

        id: String?,
        tree_id: String?,
        timestamp: String?,
        committer: CommitAuthor?,
        added: Array(String)?,
        removed: Array(String)?,
        modified: Array(String)?
      )
    end

    struct PushEventRepository
      rest_model(
        id: Int64,
        node_id: String,
        name: String,
        full_name: String,
        owner: User,
        private: Bool,
        description: String,
        fork: Bool,
        created_at: String,
        pushed_at: String,
        updated_at: String,
        homepage: String,
        size: Int32,
        stargazers_count: Int32,
        watchers_count: Int32,
        language: String,
        has_issues: Bool,
        has_downloads: Bool,
        has_wiki: Bool,
        has_pages: Bool,
        forks_count: Int32,
        open_issues_count: Int32,
        default_branch: String,
        master_branch: String,
        organization: String,
        url: String,
        archive_url: String,
        html_url: String,
        statuses_url: String,
        git_url: String,
        ssh_url: String,
        clone_url: String,
        svn_url: String
      )
    end

    struct PushEventRepoOwner
      rest_model(
        name: String,
        email: String
      )
    end

    struct ReleaseEvent
      rest_model(
        action: String,
        release: RepositoryRelease,

        repo: { key: "repository", type: Repository? },
        sender: User?,
        installation: Installation?
      )
    end

    struct RepositoryEvent
      rest_model(
        action: String,
        repo: { key: "repository", type: Repository },

        org: { key: "organization", type: Organization? },
        sender: User?,
        installation: Installation?
      )
    end

    struct RepositoryVulnerabilityAlertEvent
      rest_model(
        action: String,

        alert: RepositoryVulnerabilityAlertEvent::Alert
      )

      struct Alert
        rest_model(
          id: Int64,
          affected_range: String,
          affected_package_name: String,
          external_reference: String,
          external_identifier: String,
          fixed_id: String,
          dismisser: User,
          dismiss_reason: String,
          dismissed_at: String
        )
      end
    end

    struct StarEvent
      rest_model(
        action: String,

        starred_at: String?
      )
    end

    struct StatusEvent
      rest_model(
        sha: String,

        state: String,
        description: String,
        target_url: String,
        branches: Array(Branch),

        id: Int64?,
        name: String?,
        context: String?,
        commit: RepositoryCommit?,
        created_at: String?,
        updated_at: String?,
        repo: { key: "repository", type: Repository? },
        sender: User?,
        installation: Installation?
      )
    end

    struct TeamEvent
      rest_model(
        action: String,
        team: Team,
        changes: TeamChange,
        repo: { key: "repository", type: Repository },

        org: { key: "organization", type: Organization? },
        sender: User?,
        installation: Installation?
      )
    end

    struct TeamAddEvent
      rest_model(
        team: Team,
        repo: { key: "repository", type: Repository },

        org: { key: "organization", type: Organization? },
        sender: User?,
        installation: Installation?
      )
    end

    struct WatchEvent
      rest_model(
        action: String,

        repo: { key: "repository", type: Repository? },
        sender: User?,
        installation: Installation?
      )
    end
  end
end
