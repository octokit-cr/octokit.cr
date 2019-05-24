require "halite"
require "./authentication"

module Octokit
  module Connection
    include Octokit::Authentication

    @last_response : Halite::Response? = nil

    @agent : Halite::Client? = nil

    protected getter last_response

    # Header keys that can be passed in options hash to {#get},{#head}
    CONVENIENCE_HEADERS = Set{"accept", "content_type"}

    # Make a HTTP GET request
    def get(url, options = nil)
      request "get", url, make_options(options)
    end

    # Make a HTTP POST request
    def post(url, options = nil)
      request "post", url, make_options(options)
    end

    # Make a HTTP PUT request
    def put(url, options = nil)
      request "put", url, make_options(options)
    end

    # Make a HTTP PATCH request
    def patch(url, options = nil)
      request "patch", url, make_options(options)
    end

    # Make a HTTP DELETE request
    def delete(url, options = nil)
      request "delete", url, make_options(options)
    end

    # Make a HTTP HEAD request
    def head(url, options = nil)
      request "head", url, make_options(options)
    end

    # Make one or more HTTP GET requests, optionally fetching
    # the next page of results from URL in Link response header based
    # on value in `#auto_paginate`.
    def paginate(
      klass : T.class,
      url : String,
      *,
      start_page = 1,
      per_page = nil,
      auto_paginate = @@auto_paginate,
      options = nil
    ) : Paginator(T) forall T
      options = make_options(options)
      Paginator(T).new(self, url, start_page, per_page, auto_paginate, options)
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

    protected def reset_agent
      @agent = nil
    end

    protected def request(method, path, options = nil)
      uri = File.join(endpoint, path)
      options = options ? Default.connection_options.merge(options) : Default.connection_options
      @last_response = response = agent.request(verb: method.to_s, uri: uri, options: options)
      handle_error(response)
      response.body
    end

    protected def request(method, path, options = nil, &block)
      uri = File.join(endpoint, path)
      options = options ? Default.connection_options.merge(options) : Default.connection_options
      @last_response = response = agent.request(verb: method, uri: uri, options: options)
      handle_error(response)
      yield response
    end

    # Executes the request, checking if it was successful
    protected def boolean_from_response(method, path, options = nil)
      request(method, path, options)
      @last_response.not_nil!.status_code == 204
    rescue Error::NotFound
      false
    end

    protected def handle_error(response)
      if (300..599).includes?(response.status_code)
        error = Error.from_response(response)
        raise error if error
      end
    end

    protected def make_options(options)
      return if options.nil?
      options.is_a?(Halite::Options) ? options : Halite::Options.new(**options)
    end

    # Returned for all paginated responses, such as with
    # `Client::Repositories#repositories`. Allows you
    # to fetch the next page, the last page, or
    # fetch all pages in a response.
    #
    # **Examples:**
    # ```
    # pages = @client.repositories
    # pp pages
    # # => #<Octokit::Connection::Paginator(Octokit::Models::Repository):0x555c3d36a000>
    # ```
    class Paginator(T)
      @last_response : Halite::Response? = nil

      # Get all collected records. This is updated every time
      # a `fetch_*` method is called.
      getter records : Array(T) = [] of T

      # Get the current page.
      getter current_page : Int32

      # Get the number of pages remaining.
      #
      # **Note:** This is only not nil after a page has been fetched.
      getter remaining : Int32? = nil

      # Get the number of total pages for this query.
      #
      # **Note:** This is only not nil after a page has been fetched.
      getter total_pages : Int32? = nil

      # Create a new instance of `Connection::Paginator`
      def initialize(
        @client : Octokit::Client,
        @url : String,
        @current_page : Int32 = 1,
        @per_page : Int32? = nil,
        @auto_paginate : Bool = Connection.auto_paginate,
        options : Halite::Options? = nil
      )
        # Don't allow the @current_page variable to be less than 1.
        @current_page = 1 if @current_page < 1

        @options = options.nil? ? Halite::Options.new : options.not_nil!

        # If auto-pagination is turned on we go ahead and fetch
        # everything at initialization.
        fetch_all if @auto_paginate
      end

      # Get the record at a specific index.
      def [](index)
        @records[index]
      end

      # Get the record at a specific index, returning `nil` if
      # the index contains no record.
      def []?(index)
        @records[index]?
      end

      # Fetch all pages.
      #
      # **Example:**
      # ```
      # @client.repositories.fetch_all # => Array(Repository)
      # ```
      #
      # **Note:** This is automatically called if `Configurable#auto_paginate`
      # is set to true.
      def fetch_all : Array(T)
        # TODO: Add rate limiting support
        while next? # && !@client.rate_limit.remaining.nil? && @client.rate_limit.remaining.not_nil! > 0
          fetch_next
        end
        records
      end

      alias_method :fetch_all, :all

      # Fetch a specific page.
      #
      # **Example:**
      # ```
      # pages = @client.repositories
      # pages.fetch_page(4) # => Array(Repository)
      # ```
      def fetch_page(page : Int32) : Array(T)?
        @current_page = page
        @options.params = @options.params.merge({"page" => page.as(Halite::Options::Type)})

        if @per_page
          @options.params = @options.params.merge({"per_page" => @per_page.as(Halite::Options::Type)})
        end

        data = @client.request(:get, @url, @options)
        @last_response = @client.last_response
        set_total_pages!

        models = Array(T).from_json(data)
        @records.concat(models)
        models
      end

      # Fetch the next page.
      #
      # **Example:**
      # ```
      # pages = @client.repositories
      # pages.fetch_next # => Array(Repository)
      # ```
      def fetch_next : Array(T)?
        return unless next?
        page = fetch_page(@current_page)
        @current_page += 1
        page
      end

      alias_method :fetch_next, :next

      # Check if there is a next page.
      #
      # **Example:**
      # ```
      # pages = @client.repositories
      # pages.fetch_next
      # pages.next? # => Bool
      # ```
      def next? : Bool
        return true if @last_response.nil?
        if links = @last_response.try { |r| r.links }
          return !!links["next"]?
        end
        false
      end

      # Fetch the previous page.
      #
      # **Example:**
      # ```
      # pages = @client.repositories
      # pages.fetch_next
      # pages.fetch_previous # => Array(Repository)
      # ```
      #
      # **Note:** This is really only useful if you want to fetch
      # records backwards for some reason. Included just in case.
      def fetch_previous : Array(T)?
        return unless previous?
        @current_page -= 1
        fetch_page(@current_page)
      end

      alias_method :fetch_previous, :previous

      # Check if there is a previous page.
      #
      # **Example:**
      # ```
      # pages = @client.repositories
      # pages.fetch_next
      # pages.previous? # => Bool
      # ```
      def previous? : Bool
        @current_page > 1
      end

      # Checks if the current page is the last page.
      #
      # **Example:**
      # ```
      # pages = @client.repositories
      # pages.fetch_all
      # pages.last? # => Bool
      # ```
      def last?
        @current_page == @total_pages
      end

      # Checks if the paginator is empty.
      def empty?
        @records.empty?
      end

      # Utility method to set the `@total_pages` variable.
      private def set_total_pages!
        # return if @last_response.nil?
        # last = @last_response.not_nil!.links.not_nil!["last"]?
        # if last
        #   parsed_uri = URI.parse(last.target)
        #   return if parsed_uri.query.nil?
        #   query = parsed_uri.query.not_nil!.split('?').last.split('&').map(&.split('=')).to_h
        #   return if !query["last"]?
        #   @total_pages = query["last"].not_nil!.to_i
        # end
      end
    end
  end
end
