require "./spec_helper"

describe Octokit do
  it "sets defaults" do
    pp Halite.get("https://coveralls.io")
  end
end
