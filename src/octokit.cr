require "./octokit/default"
require "./octokit/client"
require "./octokit/enterprise_admin_client"
require "./octokit/enterprise_management_console_client"

# Crystal toolkit for the GitHub API
module Octokit
  include Octokit::Configurable

  @@client : Octokit::Client? = nil

  # @@enterprise_admin_client : Octokit::EnterpriseAdminClient? = nil

  # @@enterprise_management_console_client : Octokit::EnterpriseManagementConsoleClient? = nil

  # API client based on configuration options {`Configurable`}
  def self.client
    return @@client unless @@client.nil? && @@client.same_options?(options)
    @@client = Octokit::Client.new(options)
  end

  # EnterpriseAdminClient client based on configured options {`Configurable`}
  def self.enterprise_admin_client
  end

  # EnterpriseManagementConsoleClient client based on configured options {`Configurable`}
  def self.enterprise_management_console_client
  end
end

# c = Octokit::Client.new("watzon", "wYZ3Ud@S@jVgu2jq")
# # c.api_endpoint = "https://hookb.in/Xk999BlYQRsbobmZEbqx"
# puts c.get("/user/repos?page=1&per_page=10")
