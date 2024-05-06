require "../../src/octokit"
require "json"
require "spec"

describe Octokit do
  github = Octokit.client

  describe ".get" do
    context "when fetching info about the octokit.cr repo" do
      repo_data = github.get("/repos/GrantBirki/octokit.cr")
      repo_data = JSON.parse(repo_data)

      it "should have a name" do
        repo_data["name"].should eq("octokit.cr")
      end

      it "should have a description" do
        repo_data["description"].to_s.downcase =~ /crystal/
      end

      it "should have a html_url" do
        repo_data["html_url"] =~ /github.com/
      end
    end
  end
end
