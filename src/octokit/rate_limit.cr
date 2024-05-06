module Octokit
  # Class for API Rate Limit info
  #
  # **See Also:**
  # - [https://developer.github.com/v3/#rate-limiting](https://developer.github.com/v3/#rate-limiting)
  struct RateLimit
    property limit : Int32? = nil

    property remaining : Int32? = nil

    property resets_at : Time? = nil

    property resets_in : Int64? = nil

    def initialize(
      @limit : Int32? = nil,
      @remaining : Int32? = nil,
      @resets_at : Time? = nil,
      @resets_in : Int32? = nil
    )
    end

    # Get rate limit info from HTTP response
    def self.from_response(response)
      info = new
      if response && !response.headers.nil?
        limit = (response.headers["X-RateLimit-Limit"] || 1).to_i
        remaining = (response.headers["X-RateLimit-Remaining"] || 1).to_i
        resets_at = Time.unix(
          response.headers["X-RateLimit-Reset"]? ? response.headers["X-RateLimit-Reset"].to_i64 : Time.utc.to_unix
        )
        resets_in = [(resets_at - Time.utc).to_i, 0_i64].max

        info.limit = limit
        info.remaining = remaining
        info.resets_at = resets_at
        info.resets_in = resets_in
      end

      info
    end
  end
end
