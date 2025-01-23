require "./auth"

github = GitHubAuthentication.login

github.add_comment("<owner>/<repo>", 123, "some comment here")
