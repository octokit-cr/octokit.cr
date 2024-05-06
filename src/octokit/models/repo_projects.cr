require "../helpers"

module Octokit
  module Models
    struct ProjctListOptions
      Octokit.rest_model({
        state: String,
        # }.merge(ListOptions::FIELDS))
      })
    end
  end
end
