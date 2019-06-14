require "./octokit/core_ext/*"
require "./octokit/macros"
require "./octokit/helpers"
require "./octokit/default"
require "./octokit/client"
require "./octokit/enterprise_admin_client"
require "./octokit/enterprise_management_console_client"

# Crystal toolkit for the GitHub API.
#
# **Note:** All examples contained herein assume that `@client` is an instantiated
# `Octokit::Client` with a valid user configured.
module Octokit
  include Octokit::Configurable

  @@client : Octokit::Client? = nil

  # @@enterprise_admin_client : Octokit::EnterpriseAdminClient? = nil

  # @@enterprise_management_console_client : Octokit::EnterpriseManagementConsoleClient? = nil

  # API client based on configuration options in `Configurable`
  def self.client(
    login = nil,
    password = nil,
    *,
    access_token = nil,
    bearer_token = nil,
    client_id = nil,
    client_secret = nil
  )
    @@client.nil? ? Octokit::Client.new(
      login,
      password,
      access_token,
      bearer_token,
      client_id,
      client_secret
    ) : @@client.not_nil!
  end

  # EnterpriseAdminClient client based on configuration options in `Configurable`
  def self.enterprise_admin_client
    raise "not implemented!"
  end

  # EnterpriseManagementConsoleClient client based on configuration options in `Configurable`
  def self.enterprise_management_console_client
    raise "not implemented!"
  end
end

Octokit.reset!

client = Octokit.client(login: "watzon", password: "xJGBSG5dmqoc7D")
pp client.authorizations
