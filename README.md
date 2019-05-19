# Octokit

Crystal toolkit for the GitHub API.

**Note:** This is in the very early stages of development. The GitHub API is expansive and there is a lot to do to get this up and running. For a list of API connections that have been completed and are still to come, see the [Roadmap](#roadmap)

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
 octokit:
   github: watzon/octokit
```

2. Run `shards install`

## Usage

```crystal
require "octokit"

# Create a new Octokit Client
github = Octokit::Client.new("watzon", "PASSWORD")

# Fetch information about the logged in user
pp github.user

# Fetch information about another user
pp github.user("asterite")
```

There are way too many options to list here, even at this early stage. For information on all Client API methods see [the octokit/client source files](). *Documentation coming soon.*

## Roadmap

There are a lot of pieces of the GitHub API to cover. Here are the ones that need to be working before this shard is considered v1.0 ready.

- [ ] [Apps]()
- [ ] [Authorizations]()
- [ ] [Checks]()
- [ ] [CommitComments]()
- [ ] [Commits]()
- [ ] [CommunityProfile]()
- [ ] [Contents]()
- [ ] [Deployments]()
- [ ] [Downloads]()
- [ ] [Emojis]()
- [ ] [Events]()
- [ ] [Feeds]()
- [ ] [Gists]()
- [ ] [Gitignore]()
- [ ] [Hooks]()
- [ ] [Issues]()
- [ ] [Labels]()
- [ ] [LegacySearch]()
- [ ] [Licenses]()
- [ ] [Markdown]()
- [ ] [Marketplace]()
- [ ] [Meta]()
- [ ] [Milestones]()
- [ ] [Notifications]()
- [ ] [Objects]()
- [ ] [Organizations]()
- [ ] [Pages]()
- [ ] [Projects]()
- [ ] [PubSubHubbub]()
- [ ] [PullRequests]()
- [ ] [RateLimit]()
- [ ] [Reactions]()
- [ ] [Refs]()
- [ ] [Releases]()
- [ ] [Repositories]()
- [ ] [RepositoryInvitations]()
- [ ] [Reviews]()
- [ ] [Say]()
- [ ] [Search]()
- [ ] [ServiceStatus]()
- [ ] [SourceImport]()
- [ ] [Stats]()
- [ ] [Statuses]()
- [ ] [Traffic]()
- [x] [Users]()

I am trying to complete what I deem the most important ones first so that this shard can be immediately useful. Keep in mind, however, that the API may change at any time.

## Contributing

1. Fork it (<https://github.com/watzon/octokit/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Chris Watson](https://github.com/watzon) - creator and maintainer
