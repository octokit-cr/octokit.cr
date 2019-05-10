require "./octokit/client"

# TODO: Write documentation for `Octokit`
module Octokit
  VERSION = "0.1.0"

  # TODO: Put your code here
end

c = Octokit::Client.new("watzon", "wYZ3Ud@S@jVgu2jq")
puts c.get("https://google.com")
