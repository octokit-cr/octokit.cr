require "base64"
require "halite"
require "./authentication"
require "./macros"

module Octokit
  module Connection
    include Octokit::Authentication

    getter last_response : Halite::Response? = nil

    @agent : Halite::Client? = nil

    protected getter last_response

    # Header keys that can be passed in options hash to {#get},{#head}
    CONVENIENCE_HEADERS = Set{"accept", "content_type"}

    # Successful status codes from PUT/POST/PATCH requests
    SUCCESSFUL_STATUSES = [201, 202, 204]

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
      start_page = nil,
      per_page = nil,
      auto_paginate = @auto_paginate,
      options = nil
    ) : Paginator(T) forall T
      options = make_options(options)
      Paginator(T).new(self, url, start_page, per_page, auto_paginate, options)
    end

    # ditto
    def paginate(
      klass : T.class,
      url : String,
      *,
      start_page = nil,
      per_page = nil,
      auto_paginate = @auto_paginate,
      options = nil,
      &
    )
      paginator = Paginator(T).new(self, url, start_page, per_page, auto_paginate, options)
      while paginator.next?
        data = fetch_next
        yield(data, paginator)
      end
      paginator
    end

    # Hypermedia agent for the GitHub API
    def agent
      @agent ||= Halite::Client.new do
        if basic_authenticated?
          basic_auth(@login.to_s, @password.to_s)
        elsif token_authenticated?
          auth("Token #{@access_token.to_s}")
        elsif bearer_authenticated?
          auth("Bearer #{@access_token.to_s}")
        end
        user_agent(@user_agent)
        accept(Default::MEDIA_TYPE)
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

    protected def request(method : Symbol | String, path : String, options = nil)
      path = File.join(endpoint, path) unless path.nil? || path.starts_with?("http")
      options = options ? @connection_options.merge(options) : @connection_options
      @last_response = response = agent.request(verb: method.to_s, uri: path, options: options)
      handle_error(response)
      response.body
    end

    protected def request(method : Symbol | String, path : String, options = nil, &)
      path = File.join(endpoint, path) unless path.nil? || path.starts_with?("http")
      options = options ? @connection_options.merge(options) : @connection_options
      @last_response = response = agent.request(verb: method, uri: path, options: options)
      handle_error(response)
      yield response
      response.body
    end

    # Executes the request, checking if it was successful
    protected def boolean_from_response(method : Symbol, path : String, options : NamedTuple | Nil = nil) : Bool
      request(method, path, make_options(options))
      @last_response.not_nil!.status_code.in?(SUCCESSFUL_STATUSES)
    rescue Error::NotFound
      false
    end

    protected def handle_error(response)
      if (300..599).includes?(response.status_code)
        error = Error.from_response(response)
        raise error if error
      end
    end

    protected def make_options(options) : Halite::Options?
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
      getter last_response : Halite::Response? = nil

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
        current_page : Int32? = nil,
        @per_page : Int32? = nil,
        auto_paginate : Bool? = nil,
        options : Halite::Options? = nil
      )
        @auto_paginate = auto_paginate.nil? ? @client.auto_paginate : auto_paginate

        # Don't allow the @current_page variable to be less than 1.
        @current_page = current_page.nil? || current_page < 0 ? 0 : current_page

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

        begin
          data = @client.request(:get, @url, @options)
          set_total_pages!
          models = Array(T).from_json(data)
          @records.concat(models)
          models
        rescue Octokit::Error::NotFound
          @total_pages = 0
          [] of T
        end
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
        @current_page += 1
        fetch_page(@current_page)
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
        if total_pages = @total_pages
          return true if @current_page < total_pages && total_pages != 0
          false
        else
          true
        end
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
        @current_page > 0
      end

      # Checks if the current page is the last page.
      #
      # **Example:**
      # ```
      # pages = @client.repositories
      # pages.fetch_all
      # pages.last? # => Bool
      # ```
      def last? : Bool
        @current_page == @total_pages
      end

      # Checks if the paginator is empty.
      def empty? : Bool
        @records.empty?
      end

      # Utility method to set the `@total_pages` variable.
      private def set_total_pages!
        return @total_pages = 0 if @client.last_response.nil?
        if links = @client.last_response.try(&.links)
          unless links["last"]?
            @total_pages = 1
            return
          end
          if target = links["last"].target
            if match = target.match(/page=([0-9]+)/)
              @total_pages = match[1].to_i
            end
          end
        else
          @total_pages = 1
        end
      end
    end
  end
end
