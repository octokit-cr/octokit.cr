require "halite"
require "./authentication"

module Octokit
  module Connection
    include Octokit::Authentication

    @last_response : Halite::Response? = nil

    @agent : Halite::Client? = nil

    # Header keys that can be passed in options hash to {#get},{#head}
    CONVENIENCE_HEADERS = Set{"accept", "content_type"}

    # Make a HTTP GET request
    def get(url, options : Halite::Options? = nil)
      request "get", url, options
    end

    # Make a HTTP POST request
    def post(url, options : Halite::Options? = nil)
      request "post", url, options
    end

    # Make a HTTP PUT request
    def put(url, options : Halite::Options? = nil)
      request "put", url, options
    end

    # Make a HTTP PATCH request
    def patch(url, options : Halite::Options? = nil)
      request "patch", url, options
    end

    # Make a HTTP DELETE request
    def delete(url, options : Halite::Options? = nil)
      request "delete", url, options
    end

    # Make a HTTP HEAD request
    def head(url, options : Halite::Options? = nil)
      request "head", url, options
    end

    # Make one or more HTTP GET requests, optionally fetching
    # the next page of results from URL in Link response header based
    # on value in `#auto_paginate`.
    def paginate(klass, url, options : Halite::Options? = nil)
      # opts = parse_query_and_convenience_headers(options)
      # if @auto_paginate || @per_page
      #   opts = opts.merge({ query: { per_page: @per_page || (@auto_paginate ? 100 : nil) } })
      # end

      # data = request(:get, url, opts)

      # if @auto_paginate
      #   while @last_response.links["next"] && rate_limit.remaining > 0
      #     @last_response = @last_response.links["next"]
      #   end
      # end
      res = get url, options
      klass.from_json(res)
    end

    # ditto
    def paginate(url, options : Halite::Options? = nil, &block)

    end

    # Hypermedia agent for the GitHub API
    def agent
      @agent ||= Halite::Client.new do
        # headers accept: default_media_type
        headers content_type: "application/json"
        # headers user_agent: user_agent
        if basic_authenticated?
          basic_auth(@login.to_s, @password.to_s)
        elsif token_authenticated?
          auth("token #{@access_token}")
        elsif bearer_authenticated?
          auth("Bearer #{@bearer_token}")
        end
      end
    end

    # Fetch the root resource for the API
    def root
      get "/"
    end

    # Response for last HTTP request
    def last_response
      @last_response
    end

    protected def endpoint
      api_endpoint
    end

    private def reset_agent
      @agent = nil
    end

    private def request(method, path, options : Halite::Options? = nil)
      uri = File.join(endpoint, path)
      options = options ? Default.connection_options.merge(options) : Default.connection_options
      @last_response = response = agent.request(verb: method.to_s, uri: uri, options: options)
      response.body
    end

    private def request(method, path, options : Halite::Options? = nil, &block)
      uri = File.join(endpoint, path)
      options = options ? Default.connection_options.merge(options) : Default.connection_options
      @last_response = response = agent.request(verb: method, uri: uri, options: options)
      yield response
    end

    # Executes the request, checking if it was successful
    private def boolean_from_response(method, path, options : Halite::Options? = nil)
      request(method, path, options)
      @last_response.not_nil!.status_code == 204
    rescue Error::NotFound
      false
    end

    # private def parse_query_and_convenience_headers(options)
    #   options = options.dup
    #   headers = options.delete("headers") { {} of String => String }
    #   CONVENIENCE_HEADERS.each do |h|
    #     if header = options.delete(h)
    #       headers[h] = header
    #     end
    #   end
    #   query = options.delete("query")
    #   opts = {"query" => options}
    #   opts["query"].merge!(query) if query && query.is_a?(Hash)
    #   opts["headers"] = headers unless headers.empty?

    #   opts
    # end
  end
end
