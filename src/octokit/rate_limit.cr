module Octokit
  # Class for API Rate Limit info
  #
  # **See Also:**
  # - [https://developer.github.com/v3/#rate-limiting](https://developer.github.com/v3/#rate-limiting)
  struct RateLimit
    property limit : Int32? = nil

    property remaining : Int32? = nil

    property resets_at : Time? = nil

    property resets_in : Int32? = nil

    def initialize(@limit : Int32, @remaining : Int32, @resets_at : Time, @resets_in : Int32)
    end

    # Get rate limit info from HTTP response
    def self.from_response(response)
      info = new
      if response && !response.headers.nil?
        info.limit = (response.headers["X-RateLimit-Limit"] || 1).to_i
        info.remaining = (response.headers["X-RateLimit-Remaining"] || 1).to_i
        info.resets_at = Time.unix(response.headers["X-RateLimit-Reset"]? || Time.unix)
        info.resets_in = [(info.resets_at - Time.now).to_i, 0].max
      end

      info
    end
  end
end
