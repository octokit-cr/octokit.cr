require "../../src/octokit"
require "json"
require "spec"

describe Octokit do
  github = Octokit.client
  github.auto_paginate = true
  github.per_page = 100

  describe ".get" do
    context "when fetching info about the octokit.cr repo" do
      repo_data = github.get("/repos/octokit-cr/octokit.cr")
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

  describe "pull requests" do
    context "fetches closed pull requests" do
      pulls = github.pull_requests("octokit-cr/octokit.cr", state: "closed").records

      it "should find at least one closed pull request" do
        pulls.size.should be > 0
      end

      it "should fetch the title of the first closed pull request" do
        pulls.first.title.should_not be_nil
      end
    end

    context "fetches pull request comments" do
      comments = github.pull_request_comments("octokit-cr/octokit.cr", 15).records

      it "should find at least one comment" do
        comments.size.should be > 0
      end

      it "should fetch the body of the first comment" do
        comments.first.body.should_not be_nil
      end

      it "should fetch the diff_hunk of the first comment" do
        comments.first.diff_hunk.should_not be_nil
      end

      it "should fetch the path of the first comment" do
        comments.first.path.should_not be_nil
      end

      it "should fetch the position of the first comment" do
        comments.first.position.should_not be_nil
      end

      it "should fetch the ID of the first comment" do
        comments.first.id.should_not be_nil
      end
    end

    context "fetches pull request files" do
      files = github.pull_request_files("octokit-cr/octokit.cr", 15).records

      it "should find at least one file" do
        files.size.should be > 0
      end

      it "should fetch the filename of the first file" do
        files.first.filename.should_not be_nil
      end

      it "should fetch the sha of the first file" do
        files.first.sha.should_not be_nil
      end

      it "should fetch the status of the first file" do
        files.first.status.should_not be_nil
      end

      it "should fetch the additions of the first file" do
        files.first.additions.should_not be_nil
      end

      it "should fetch the deletions of the first file" do
        files.first.deletions.should_not be_nil
      end

      it "should fetch the contents_url of the first file" do
        files.first.contents_url.should_not be_nil
      end

      it "should fetch the patch of the first file" do
        files.first.patch.should_not be_nil
      end

      it "should fetch the sha of the second file" do
        files[1].sha.should_not be_nil
      end
    end

    context "merged pull request" do
      pull = github.pull_merged?("octokit-cr/octokit.cr", 15)

      it "checks if the pull request is merged and finds that it is" do
        pull.should eq true
      end
    end
  end
end
