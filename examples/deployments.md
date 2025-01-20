# Deployments

This example shows how you can interact with GitHub deployments using the `octokit.cr` library:

```crystal
require "octokit"

github = Octokit.client(access_token: ENV.fetch("GITHUB_TOKEN"))
github.auto_paginate = true
github.per_page = 100

repo = "owner/repo"

puts "################ list deployments ################"
deployments = github.deployments(repo, {"environment" => "production"})
deployments.records.each do |deployment|
  puts "deployment.id: #{deployment.id}"
  puts "deployment.sha: #{deployment.sha}"
  puts "deployment.description: #{deployment.description}"
  puts "deployment.payload: #{deployment.payload}"
  puts "deployment.environment: #{deployment.environment}"
end

puts "################ create_deployment ################"
deployment = github.create_deployment(repo, "main", description: "Deploying from octokit.cr", payload: { "foo" => "bar" })
puts "created deployment: #{deployment.id}"

puts "################ get deployment ################"
deployment_id = deployment.id
the_deployment = github.deployment(repo, deployment_id)
puts "deployment.id: #{the_deployment.id}"
puts "deployment.sha: #{the_deployment.sha}"
puts "deployment.payload: #{the_deployment.payload}"
puts "deployment.payload['foo']: #{the_deployment.payload["foo"]}"
puts "deployment.environment: #{the_deployment.environment}"

puts "################ create_deployment_status ################"
github.create_deployment_status(repo, deployment_id, "in_progress")
result = github.create_deployment_status(repo, deployment_id, "success")
result.id

puts "################ get deployment status ################"
status = github.deployment_status(repo, deployment_id, result.id)
puts "status.state: #{status.state}"

puts "################ list deployment statuses ################"
statuses = github.list_deployment_statuses(repo, deployment_id)
statuses.records.each do |s|
  puts "status.id: #{s.id}"
end
```
