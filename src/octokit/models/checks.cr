module Octokit
  module Models
    struct CheckRun
      rest_model(
        id: Int64,
        node_id: String,
        head_sha: String,
        external_id: String,
        url: String,
        html_url: String,
        details_url: String,
        conclusion: String,
        started_at: Timestamp,
        completed_at: Timestamp,
        output: CheckRunOutput,
        name: String,
        check_suite: CheckSuite,
        app: App,
        pull_requests: Array(PullRequests)
      )
    end

    struct CheckRunOutput
      rest_model(
        title: String,
        summary: String,
        text: String,
        annotations_count: Int32,
        annotations: Array(CheckRunAnnotation),
        images: Array(CheckRunImage)
      )
    end

    struct CheckRunAnnotation
      rest_model(
        path: String,
        blob_href: String,
        start_line: Int32,
        end_line: Int32,
        annotation_level: String,
        message: String,
        title: String,
        raw_deals: String
      )
    end

    struct CheckRunImage
      rest_model(
        alt: String,
        image_url: String,
        caption: String
      )
    end

    struct CheckSuite
      rest_model(
        id: Int64,
        node_id: String,
        head_branch: String,
        head_sha: String,
        url: String,
        before_sha: String,
        after_sha: String,
        status: String,
        conclusion: String,
        app: App,
        repository: Repository,
        pull_requests: Array(PullRequest)
      )
    end
  end
end
