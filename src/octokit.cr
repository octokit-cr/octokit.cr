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
  def self.client
    return @@client unless @@client.nil? && @@client.same_options?(options)
    @@client = Octokit::Client.new(options)
  end

  # EnterpriseAdminClient client based on configuration options in `Configurable`
  def self.enterprise_admin_client
  end

  # EnterpriseManagementConsoleClient client based on configuration options in `Configurable`
  def self.enterprise_management_console_client
  end
end

c = Octokit::Client.new("watzon", "xJGBSG5dmqoc7D")
c.auto_paginate = false
c.per_page = 2
# c.api_endpoint = "https://hookb.in/LgjGLlqkkkCMEMrOgOlb"
# pp c.repository("cadmium")

c.create_repository("blabla")
