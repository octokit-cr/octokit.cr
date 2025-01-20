# Reactions

This example shows how you can interact with GitHub reactions using the `octokit.cr` library:

```crystal
require "octokit"

github = Octokit.client(access_token: ENV.fetch("GITHUB_TOKEN"))
github.auto_paginate = true
github.per_page = 100

# Get all the comments on a given issue
issue_comments = github.issue_comments("grantbirki/actions-sandbox", 126)

# Grab the first comment
first_issue_comment = issue_comments.records.first

# Get all the reactions on the first comment
reactions = github.issue_comment_reactions("grantbirki/actions-sandbox", first_issue_comment.id)

# Methods that return paginated results will return a Paginator object. This object has a `records` method that returns the actual results. Records in this case will be an Array of `Reaction` objects
reactions.records.each do |reaction|
  puts reaction.content    # --> "+1" (example)
  puts reaction.user.login # --> "octocat" (example)
  puts reaction.id         # --> 123456 (example)
end
```
