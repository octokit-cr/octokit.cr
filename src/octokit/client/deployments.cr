require "uri"
require "../models/repos"
require "../models/repo_deployments"

module Octokit
  class Client
    # Methods for the Deployments API
    #
    # All "repo" params are constructed in the format of `<organization>/<repository>`
    #
    # **See Also:**
    # - [https://developer.github.com/v3/repos/commits/deployments/](https://developer.github.com/v3/repos/commits/deployments/)

    module Deployments
      # :nodoc:
      alias Repository = Models::Repository

      # :nodoc:
      VALID_STATES = %w[error failure inactive in_progress queued pending success]

      # Fetch a single deployment for a repository
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/deployments/#get-a-single-deployment](https://developer.github.com/v3/repos/deployments/#get-a-single-deployment)
      #
      # **Examples:**
      #
      # Fetch a single deployment for a repository
      #
      # ```
      # Octokit.deployment("monsalisa/app", 123456)
      # ```
      def deployment(repo : String, deployment_id : Int64, **options)
        get("#{Repository.path(repo)}/deployments/#{deployment_id}", options)
      end

      # List deployments for a repository
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/deployments/#list-deployments](https://developer.github.com/v3/repos/deployments/#list-deployments)
      #
      # **Examples:**
      # List deployments for a repository
      #
      # ```
      # Octokit.deployments("monalisa/app")
      # ```
      #
      # Filter deployments by environment:
      # ```
      # Octokit.deployments("monalisa/app", {"environment" => "production"})
      # ```
      # An alias method exists for `deployments` called `list_deployments` which can be used interchangeably
      def deployments(repo : String, params : Hash(String, String) = {} of String => String, **options)
        query_string = params.map { |k, v| "#{URI.encode_path(k)}=#{URI.encode_path(v)}" }.join("&")
        url = "#{Repository.path(repo)}/deployments"
        url += "?#{query_string}" unless query_string.empty?
        get(url, options)
      end

      # Alias for `deployments`
      def list_deployments(repo : String, params : Hash(String, String) = {} of String => String, **options)
        deployments(repo, params, **options)
      end

      # Create a deployment for a ref
      # The ref parameter can be any named branch, tag, or SHA
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/deployments/#create-a-deployment](https://developer.github.com/v3/repos/deployments/#create-a-deployment)
      #
      # **Examples:**
      # Create a deployment for a ref
      #
      # ```
      # Octokit.create_deployment("monalisa/app", "main")
      # ```
      #
      # ```
      # Octokit.create_deployment("monalisa/app", "main", description: "Deploying main branch!")
      # ```
      def create_deployment(
        repo : String, # in org/repo format (required)
        ref : String,  # The ref to deploy. This can be a branch, tag, or SHA. (required)
        task : String = "deploy",
        auto_merge : Bool = true,
        required_contexts : Array(String)? = nil,
        payload : Hash(String, String) = {} of String => String,
        environment : String = "production",
        description : String = "",
        transient_environment : Bool = false,
        production_environment : Bool = true,
        **options
      )
        options = options.merge({
          json: {
            ref:                    ref,
            task:                   task,
            auto_merge:             auto_merge,
            required_contexts:      required_contexts,
            payload:                payload,
            environment:            environment,
            description:            description,
            transient_environment:  transient_environment,
            production_environment: production_environment,
          },
        })

        post("#{Repository.path(repo)}/deployments", options)
      end

      # Delete a Deployment
      #
      # If the repository only has one deployment, you can delete the deployment regardless of its status. If the repository has more than one deployment, you can only delete inactive deployments. This ensures that repositories with multiple deployments will always have an active deployment.
      #
      # To set a deployment as inactive, you must:
      #
      # Create a new deployment that is active so that the system has a record of the current state, then delete the previously active deployment.
      # Mark the active deployment as inactive by adding any non-successful deployment status.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/deployments/#delete-a-deployment](https://developer.github.com/v3/repos/deployments/#delete-a-deployment)
      # **Examples:**
      #
      # ```
      # Octokit.delete_deployment("monalisa/app", 123456)
      # ```
      def delete_deployment(repo : String, deployment_id : Int64, **options)
        delete("#{Repository.path(repo)}/deployments/#{deployment_id}", options)
      end

      # Get a deployment status
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/deployments/#get-a-deployment-status](https://developer.github.com/v3/repos/deployments/#get-a-deployment-status)
      #
      # **Examples:**
      #
      # ```
      # Octokit.deployment_status("monalisa/app", 1234567890, 1234567890)
      # ```
      def deployment_status(repo : String, deployment_id : Int64, status_id : Int64, **options)
        get("#{Repository.path(repo)}/deployments/#{deployment_id}/statuses/#{status_id}", options)
      end

      # List all statuses for a Deployment
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/deployments/#list-deployment-statuses](https://developer.github.com/v3/repos/deployments/#list-deployment-statuses)
      #
      # **Examples:**
      #
      # ```
      # Octokit.deployment_statuses("monalisa/app", 1234567890)
      # ```
      #
      # You should use a paginated octokit instance to fetch all statuses:
      #
      # ```
      # client = Octokit.client
      # client.auto_paginate = true
      # client.per_page = 100
      #
      # data = client.deployment_statuses("monalisa/app", 1234567890)
      # puts data.records.to_pretty_json
      # ```
      #
      # Returns an array of deployment statuses
      def deployment_statuses(repo : String, deployment_id : Int64, **options) : Paginator(Octokit::Models::DeploymentStatus)
        paginate(
          Octokit::Models::DeploymentStatus,
          "#{Repository.path(repo)}/deployments/#{deployment_id}" + "/statuses",
          start_page: options[:page]?,
          per_page: options[:per_page]?
        )
      end

      # alias for `deployment_statuses`
      def list_deployment_statuses(repo : String, deployment_id : Int64, **options) : Paginator(Octokit::Models::DeploymentStatus)
        deployment_statuses(repo, deployment_id, **options)
      end

      # Create a deployment status for a Deployment
      #
      # :param repo [String]: The repository to create a deployment status for in org/repo format (required)
      # :param deployment_id [Integer]: The deployment id (required)
      # :param state: can be one of the following: error, failure, inactive, in_progress, queued, pending, success
      # :param options [String]: :target_url The target URL to associate with this status. Default: ""
      # :param options [String]: :description A short description of the status. Maximum length of 140 characters. Default: ""
      # :return: A deployment status
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/deployments/#create-a-deployment-status](https://developer.github.com/v3/repos/deployments/#create-a-deployment-status)
      #
      # **Examples:**
      #
      # ```
      # Octokit.create_deployment_status("monalisa/app", 1234567890, "success")
      # ```
      def create_deployment_status(
        repo : String,         # in org/repo format (required)
        deployment_id : Int64, # The deployment id (required)
        state : String,        # The state of the status (required)
        target_url : String = "",
        log_url : String = "",
        description : String = "",
        environment : String? = nil,
        environment_url : String = "",
        auto_inactive : Bool = true,
        **options
      )
        raise "ArgumentError: state must be one of error, failure, inactive, in_progress, queued, pending, success" unless VALID_STATES.includes?(state)

        options = options.merge({
          json: {
            state:           state.downcase,
            target_url:      target_url,
            log_url:         log_url,
            description:     description,
            environment:     environment,
            environment_url: environment_url,
            auto_inactive:   auto_inactive,
          },
        })

        post("#{Repository.path(repo)}/deployments/#{deployment_id}" + "/statuses", options)
      end
    end
  end
end
