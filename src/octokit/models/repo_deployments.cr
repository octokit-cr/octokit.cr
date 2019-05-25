module Octokit
  module Models
    struct Deployment
      Octokit.rest_model(
        url: String,
        id: Int64,
        sha: String,
        ref: String,
        task: String,
        payload: String,
        environment: String,
        description: String,
        creator: User,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        updated_at: {type: Time, converter: Time::ISO8601Converter},
        statuses_url: String,
        repository_url: String,
        node_id: String
      )
    end

    struct DeploymentRequest
      Octokit.rest_model(
        ref: String,
        task: String,
        auto_merge: Bool,
        required_contexts: Array(String),
        payload: String,
        environment: String,
        description: String,
        transient_environment: Bool,
        production_environment: Bool
      )
    end

    struct DeploymentsListOptions
      Octokit.rest_model({
        sha: String,

        ref: String,

        task: String,

        environment: String,
        # }.merge(ListOptions::FIELDS))
      })
    end

    struct DeploymentStatus
      Octokit.rest_model(
        id: String,

        state: String,
        creator: User,
        description: String,
        target_url: String,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        updated_at: {type: Time, converter: Time::ISO8601Converter},
        deployment_url: String,
        repository_url: String,
        node_id: String
      )
    end

    struct DeploymentStatusRequest
      Octokit.rest_model(
        state: String,
        log_url: String,
        description: String,
        environment: String,
        environment_url: String,
        auto_inactive: Bool
      )
    end
  end
end
