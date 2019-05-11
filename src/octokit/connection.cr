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
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    def get(url, options : Halite::Options? = nil)
      request "get", url, options
    end

    # Make a HTTP POST request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    def post(url, options : Halite::Options? = nil)
      request "post", url, options
    end

    # Make a HTTP PUT request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    def put(url, options : Halite::Options? = nil)
      request "put", url, options
    end

    # Make a HTTP PATCH request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    def patch(url, options : Halite::Options? = nil)
      request "patch", url, options
    end

    # Make a HTTP DELETE request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    def delete(url, options : Halite::Options? = nil)
      request "delete", url, options
    end

    # Make a HTTP HEAD request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    def head(url, options : Halite::Options? = nil)
      request "head", url, options
    end

    # Make one or more HTTP GET requests, optionally fetching
    # the next page of results from URL in Link response header based
    # on value in {#auto_paginate}.
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @param block [Block] Block to perform the data concatination of the
    #   multiple requests. The block is called with two parameters, the first
    #   contains the contents of the requests so far and the second parameter
    #   contains the latest response.
    def paginate(url, options : Halite::Options? = nil, &block)
      # if @auto_paginate || @per_page
      #   options["query"]["per_page"] ||= @per_page || (@auto_paginate ? 100 : nil)
      # end

      # data = request("get", url, options.dup)

      # if @auto_paginate
      #   while @last_response.rels["next"] && rate_limit.remaining > 0
      #     @last_response = @last_response.rels["next"].get({"headers" => options["headers"]})
      #     if block_given?
      #       yield(data, @last_response)
      #     else
      #       data.concat(@last_response.data) if @last_response.data.is_a?(Array)
      #     end
      #   end
      # end

      # data
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
      @last_response = response = agent.request(verb: method, uri: uri, options: options)
      response.body
    end

    private def request(method, path, options : Halite::Options? = nil, &block)
      uri = File.join(endpoint, path)
      options = options ? Default.connection_options.merge(options) : Default.connection_options
      @last_response = response = agent.request(verb: method, uri: uri, options: options)
      yield response
    end

    # Executes the request, checking if it was successful
    #
    # @return [Boolean] True on success, false otherwise
    private def boolean_from_response(method, path, options : Halite::Options? = nil)
      request(method, path, options)
      @last_response.status == 204
    rescue Octokit::NotFound
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
