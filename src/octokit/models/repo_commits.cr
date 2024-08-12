module Octokit
  module Models
    struct RepositoryCommit
      Octokit.rest_model(
        node_id: String,
        sha: String,
        commit: Commit,
        author: User,
        committer: User,
        parents: Array(Commit),
        html_url: String,
        url: String,
        comments_url: String,

        stats: CommitStats,
        files: Array(CommitFile)
      )
    end

    struct CommitStats
      Octokit.rest_model(
        additions: Int32,
        deletions: Int32,
        total: Int32
      )
    end

    struct CommitFile
      Octokit.rest_model(
        sha: String,
        filename: String,
        additions: Int32,
        deletions: Int32,
        changes: Int32,
        status: String,
        patch: String?,
        blob_url: String,
        raw_url: String,
        contents_url: String,
        previous_filename: String?
      )
    end

    struct CommitsComparison
      Octokit.rest_model(
        base_commit: RepositoryCommit,
        merge_base_commit: RepositoryCommit,

        status: String,
        ahead_by: Int32,
        behind_by: Int32,
        total_commits: Int32,

        commits: Array(RepositoryCommit),

        files: Array(CommitFile),

        html_url: String,
        permalink: String,
        diff_url: String,
        patch_url: String,
        url: String
      )
    end

    struct CommitListOptions
      Octokit.rest_model({
        sha: String,

        path: String,

        author: String,

        since: String,

        until: String,
        # }.merge(ListOptions::FIELDS))
      })
    end
  end
end
