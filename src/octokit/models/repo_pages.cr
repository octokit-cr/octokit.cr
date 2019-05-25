module Octokit
  module Models
    struct Pages
      Octokit.rest_model(
        url: String,
        status: String,
        cname: String,
        custom_404: String,
        html_url: String,
        source: PagesSource
      )
    end

    struct PagesSource
      Octokit.rest_model(
        branch: String,
        path: String
      )
    end

    struct PagesError
      Octokit.rest_model(
        message: String
      )
    end

    struct PagesBuild
      Octokit.rest_model(
        url: String,
        status: String,
        error: PagesError,
        pusher: User,
        commit: String,
        duration: Int32,
        created_at: {type: Time, converter: Time::ISO8601Converter},
        updated_at: String
      )
    end
  end
end
