module Octokit
  module Models
    struct SignatureVerification
      rest_model(
        verified: Bool,
        reason: String,
        signature: String,
        payload: String
      )
    end

    struct Commit
      rest_model(
        sha: String,
        author: CommitAuthor,
        committer: CommitAuthor,
        message: String,
        tree: Tree,
        parents: Array(Commit),
        stats: CommitStats,
        html_url: String,
        url: String,
        verification: SignatureVerification,
        node_id: String
      )
    end

    struct CommitAuthor
      rest_model(
        date: String,
        name: String,
        email: String,

        login: String
      )
    end
  end
end
