module Octokit
  module Models
    struct ProjctListOptions
      rest_model({
        state: String,
      }.merge(ListOptions::FIELDS))
    end
  end
end
