module Octokit
  module Models
    struct Branch
      Octokit.rest_model(
        name: String,
        commit: BranchCommit,
        protected: Bool,
        protection: BranchProtection,
        protection_url: String
      )
    end

    struct BranchCommit
      Octokit.rest_model(
        sha: String,
        url: String
      )
    end

    struct BranchProtection
      Octokit.rest_model(
        enabled: Bool,
        required_status_checks: BranchProtectionRequiredStatusChecks
      )
    end

    struct BranchProtectionRequiredStatusChecks
      Octokit.rest_model(
        enforcement_level: String,
        contexts: Array(String)
      )
    end

    struct BranchProtectionSummary
      # Octokit.rest_model # TODO
    end
  end
end
