module Octokit
  module Models
    struct MarkdownOptions
      Octokit.rest_model(
        mode: String?,

        context: String?
      )
    end

    struct MarkdownRequest
      Octokit.rest_model(
        text: String?,
        mode: String?,
        context: String?
      )
    end

    struct CodeOfConduct
      Octokit.rest_model(
        name: String,
        key: String,
        url: String,
        body: String
      )
    end

    struct APIMeta
      Octokit.rest_model(
        hooks: Array(String),

        git: Array(String),

        verifiable_password_authentication: Bool,

        pages: Array(String),

        importer: Array(String)
      )
    end
  end
end
