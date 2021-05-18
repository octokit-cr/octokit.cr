require "../src/octokit.cr"

# Create a Personal Access token https://github.com/settings/tokens
# with the following rights:
# repo
#    x public_repo
# user
#    x read:user
#    x user:email
# On the command line replace the ... and run:

# OCTOKIT_USER=... OCTOKIT_TOKEN=... crystal src/eg/example.cr

# Adding the secret envrionment variable to GitHub Actions:
# https://github.com/watzon/octokit.cr
# Settings / Secrets / New repository secret

# TODO: Maybe instead of setting our own OCTOKIT_USER we should rely on GITHUB_ACTOR that is set by default?
# TODO: For development maybe allow the saving of these values in a configuration file?


if ! ENV.has_key?("OCTOKIT_USER") || ! ENV.has_key?("OCTOKIT_TOKEN")
    puts "Both OCTOKIT_USER and OCTOKIT_TOKEN are required to run this program"
    exit(1)
end

username = ENV["OCTOKIT_USER"]
token = ENV["OCTOKIT_TOKEN"]
github = Octokit.client(username, token)

pp github.user
pp github.user("asterite")

begin
    github.user("Name with spaces")
rescue ex
    #puts ex
    if ex.class != Octokit::Error::BadRequest
        raise "Invalid exception #{ex.class}"
    end
end

#result = github.search_repositories "language:crystal", per_page: 3
#pp result.records
# if result.records.size != 3
#     raise "There are at least 3 repositories in the world with crystal as the language but we got #{result.records.size}"
# end