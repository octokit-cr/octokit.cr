module Octokit
  module Models
    struct ListOptions
      rest_model(
        page: Int32,

        per_page: Int32?
      )
    end

    struct UploadOptions
      rest_model(
        name: String,
        label: String,
        media_type: String
      )
    end

    type RawType = UInt8

    type RawOptions
      rest_model(
        type: RawType
      )
    end
  end
end
