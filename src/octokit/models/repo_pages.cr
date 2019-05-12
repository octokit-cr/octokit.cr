module Octokit
  module Models
    struct Pages
      rest_model(
        url: String,
        status: String,
        cname: String,
        custom_404: String,
        html_url: String,
        source: PagesSource
      )
    end

    struct PagesSource
      rest_model(
        branch: String,
        path: String
      )
    end

    struct PagesError
      rest_model(
        message: String
      )
    end

    struct PagesBuild
      rest_model(
        url: String,
        status: String,
        error: PagesError,
        pusher: User,
        commit: String,
        duration: Int32,
        created_at: String,
        updated_at: String
      )
    end
  end
end
