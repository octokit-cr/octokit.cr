module Octokit
  module Configurable
    @@keys : Array(String)? = nil

    class_getter access_token, auto_paginate, bearer_token, client_id, client_secret,
      default_media_type, connection_options, middleware, per_page, proxy,
      ssl_verify_mode, user_agent

    class_setter password, web_endpoint, api_endpoint, login,
      management_console_endpoint, management_console_password

    @@access_token : String? = nil
    @@auto_paginate : Bool? = nil
    @@bearer_token : String? = nil
    @@client_id : String? = nil
    @@client_secret : String? = nil
    @@default_media_type : String? = nil
    @@connection_options : Halite::Options? = nil
    @@middleware : Array(Halite::Feature)? = nil
    # @@netrc : Bool? = nil
    # @@netrc_file : String? = nil
    @@per_page : Int32? = nil
    @@proxy : String? = nil
    @@ssl_verify_mode : Int32? = nil
    @@user_agent : String? = nil

    @@password : String? = nil
    @@web_endpoint : String? = nil
    @@api_endpoint : String? = nil
    @@login : String? = nil
    @@management_console_endpoint : String? = nil
    @@management_console_password : String? = nil

    # List of configurable keys for `Octokit::Client`
    KEYS = [
      "access_token",
      "api_endpoint",
      "auto_paginate",
      "bearer_token",
      "client_id",
      "client_secret",
      "connection_options",
      "default_media_type",
      "login",
      "management_console_endpoint",
      "management_console_password",
      "middleware",
      "per_page",
      "password",
      "proxy",
      "ssl_verify_mode",
      "user_agent",
      "web_endpoint",
    ]

    def configure(&block)
      yield self
    end

    macro reset!
      {% begin %}
        {% for key in KEYS %}
          @@{{ key.id }} = Octokit::Default.options[{{ key.id.stringify }}]
        {% end %}
      {% end %}
      self
    end

    reset!

    # Compares client options to a Hash of requested options
    def same_options?(opts)
      opts.hash == options.hash
    end

    def api_endpoint
      File.join(@@api_endpoint || "", "")
    end

    def management_console_endpoint
      File.join(@@management_console_endpoint || "", "")
    end

    # Base URL for generated web URLs
    def web_endpoint
      File.join(@@web_endpoint || "", "")
    end

    def login
      @@login ||= begin
        user.login if token_authenticated?
      rescue e : Exception
      end
    end

    private macro options
      {% begin %}
        [
        {% for key in KEYS %}
          [{{key.id.stringify}}, @@{{key.id}}],
        {% end %}
        ].to_h
      {% end %}
    end
  end
end
