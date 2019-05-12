module Octokit
  module Models
    struct Metric
      Octokit.rest_model(
        name: String,
        key: String,
        url: String,
        html_url: String
      )
    end

    struct CommunityHealthFiles
      Octokit.rest_model(
        code_of_conduct: Metric,
        contributing: Metric,
        issue_template: Metric,
        pull_request_template: Metric,
        license: Metric,
        readme: Metric
      )
    end

    struct CommunityHealthMetrics
      Octokit.rest_model(
        health_percentage: Int32,
        files: CommunityHealthFiles,
        updated_at: String
      )
    end
  end
end
