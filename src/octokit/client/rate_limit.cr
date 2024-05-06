require "../connection"

module Octokit
  class Client
    # Methods for API rate limiting info
    #
    # **See Also:**
    # - [https://developer.github.com/v3/#rate-limiting](https://developer.github.com/v3/#rate-limiting)
    module RateLimit
      # Get rate limit info from last response if available
      # or make a new request to fetch rate limit
      #
      # **See Also:**
      # - [https://developer.github.com/v3/rate_limit/#rate-limit](https://developer.github.com/v3/rate_limit/#rate-limit)
      def rate_limit
        return rate_limit! if @last_response.nil?

        Octokit::RateLimit.from_response(@last_response)
      end

      alias_method :rate_limit, :ratelimit

      # Refresh rate limit info by making a new request
      #
      # **See Also:**
      # - [https://developer.github.com/v3/rate_limit/#rate-limit](https://developer.github.com/v3/rate_limit/#rate-limit)
      def rate_limit!
        get "rate_limit"
        Octokit::RateLimit.from_response(@last_response)
      end

      alias_method :rate_limit!, :ratelimit!
    end
  end
end
