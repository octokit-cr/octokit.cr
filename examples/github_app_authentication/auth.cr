require "../../src/octokit"
require "./github_app_auth"

class AuthenticationError < Exception
end

module GitHubAuthentication
  def self.login(client : Octokit::Client? = nil)
    if client
      puts "using pre-provided client"
      return client
    end

    if ENV["GITHUB_APP_ID"]? && ENV["GITHUB_APP_INSTALLATION_ID"]? && ENV["GITHUB_APP_PRIVATE_KEY"]?
      puts "using github app authentication"
      return GitHubApp.new
    end

    if token = ENV["GITHUB_TOKEN"]?
      puts "using github token authentication"
      octokit = Octokit.client(access_token: token)
      octokit.auto_paginate = true
      octokit.per_page = 100
      return octokit
    end

    raise AuthenticationError.new("No valid GitHub authentication method was provided")
  end
end
