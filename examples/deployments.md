# Deployments

This example shows how you can interact with GitHub deployments using the `octokit.cr` library:

```crystal
require "octokit"

github = Octokit.client(access_token: ENV.fetch("GITHUB_TOKEN"))
github.auto_paginate = true
github.per_page = 100

puts "################ create_deployment ################"
deployment = github.create_deployment("owner/repo", "main", description: "Deploying from octokit.cr")
deployment = JSON.parse(deployment)
puts deployment.to_pretty_json

puts "################ get deployment ################"
deployment_id = deployment["id"].as_i64
the_deployment = github.deployment("owner/repo", deployment_id)
puts JSON.parse(the_deployment).to_pretty_json

puts "################ create_deployment_status ################"
github.create_deployment_status("owner/repo", deployment_id, "in_progress")
result = github.create_deployment_status("owner/repo", deployment_id, "success")
puts JSON.parse(result).to_pretty_json

puts "################ list deployment statuses ################"
statuses = github.list_deployment_statuses("owner/repo", deployment_id)
data = JSON.parse(statuses.records.to_json)
puts data.to_pretty_json
```
