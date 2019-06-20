module Octokit
  module Models
    struct SearchOptions
      Octokit.rest_model({
        sort:       String,
        order:      String,
        text_match: Bool,
        # }.merge(ListOptions::FIELDS))
      })
    end

    struct SearchParameters
      Octokit.rest_model(
        query: String,
        repository_id: Int64
      )
    end

    struct RepositoriesSearchResult
      Octokit.rest_model(
        total_count: Int32,
        incomplete_results: Bool,
        items: Array(Repository)
      )
    end

    struct CommitsSearchResult
      Octokit.rest_model(
        sha: String,
        commit: Commit,
        author: User,
        committer: User,
        parents: Array(Commit),
        html_url: String,
        url: String,
        comments_url: String,

        repository: Repository,
        score: Float64
      )
    end

    struct IssuesSearchResult
      Octokit.rest_model(
        total: Int32,
        incomplete_results: Bool,
        issues: Array(Issue)
      )
    end

    struct UserSearchResult
      Octokit.rest_model(
        total: Int32,
        incomplete_results: Bool,
        users: Array(User)
      )
    end

    struct Match
      Octokit.rest_model(
        text: String,
        indices: Array(Int32)
      )
    end

    struct TextMatch
      Octokit.rest_model(
        object_url: String,
        object_type: String,
        property: String,
        fragment: String,
        matches: Array(Match)
      )
    end

    struct CodeSearchResult
      Octokit.rest_model(
        total: Int32,
        incomplete_results: Bool,
        code_results: Array(CodeResult)
      )
    end

    struct CodeResult
      Octokit.rest_model(
        name: String,
        path: String,
        sha: String,
        html_url: String,
        repository: Repository,
        text_matches: Array(TextMatch)
      )
    end

    struct LabelResult
      Octokit.rest_model(
        id: Int64,
        url: String,
        name: String,
        color: String,
        default: Bool,
        description: String,
        score: Float64
      )
    end
  end
end
