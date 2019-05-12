module Octokit
  module Models
    struct AdminStats
      Octokit.rest_model(
        issues: IssueStats,
        hooks: HookStats,
        milestones: MilestoneStats,
        orgs: OrgStats,
        comments: CommentStats,
        pages: PageStats,
        users: UserStats,
        gists: GistStats,
        pulls: PullStats,
        repos: RepoStats,
      )
    end

    struct IssueStats
      Octokit.rest_model(
        total_issues: Int32,
        open_issues: Int32,
        closed_issues: Int32,
      )
    end

    struct HookStats
      Octokit.rest_model(
        total_hooks: Int32,
        active_hooks: Int32,
        inactive_hooks: Int32,
      )
    end

    struct MilestoneStats
      Octokit.rest_model(
        total_milestones: Int32,
        open_milestones: Int32,
        closed_milestones: Int32
      )
    end

    struct OrgStats
      Octokit.rest_model(
        total_orgs: Int32,
        disabled_orgs: Int32,
        total_teams: Int32,
        total_team_members: Int32
      )
    end

    struct CommentStats
      Octokit.rest_model(
        total_commit_comments: Int32,
        total_gist_comments: Int32,
        total_issue_comments: Int32,
        total_pull_request_comments: Int32
      )
    end

    struct PageStats
      Octokit.rest_model(
        total_pages: Int32
      )
    end

    struct UserStats
      Octokit.rest_model(
        total_users: Int32,
        admin_users: Int32,
        suspended_users: Int32
      )
    end

    struct GistStats
      Octokit.rest_model(
        total_gists: Int32,
        private_gists: Int32,
        public_gists: Int32
      )
    end

    struct PullStats
      Octokit.rest_model(
        total_pulls: Int32,
        merged_pulls: Int32,
        mergable_pulls: Int32,
        unmergable_pulls: Int32
      )
    end

    struct RepoStats
      Octokit.rest_model(
        total_repos: Int32,
        root_repos: Int32,
        fork_repos: Int32,
        org_repos: Int32,
        total_pushes: Int32,
        total_wikis: Int32
      )
    end
  end
end
