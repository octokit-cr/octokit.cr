module Octokit
  module Models
    struct ListOptions
      Octokit.rest_model(
        page: Int32,

        per_page: Int32?
      )
    end

    struct UploadOptions
      Octokit.rest_model(
        name: String,
        label: String,
        media_type: String
      )
    end

    alias RawType = UInt8

    struct RawOptions
      Octokit.rest_model(
        type: RawType
      )
    end
  end
end
