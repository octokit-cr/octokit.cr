module Octokit
  module Models
    struct Reaction
      rest_model(
        id: Int64,
        user: User,
        node_id: String,

        content: String
      )
    end

    struct Reactions
      rest_model(
        total_count: Int32,
        plus_one: Int32,
        minus_one: Int32,
        laugh: Int32,
        confused: Int32,
        heart: Int32,
        hooray: Int32,
        url: String
      )
    end
  end
end
