require "mime"

module Octokit
  class Client
    # Methods for the Releases API
    #
    # **See Also:**
    # - [https://developer.github.com/v3/repos/releases/](https://developer.github.com/v3/repos/releases/)
    module Releases
      # :nodoc:
      alias Repository = Models::Repository

      # :nodoc:
      alias RepositoryRelease = Models::RepositoryRelease

      # :nodoc:
      alias ReleaseAsset = Models::ReleaseAsset

      # List releases for a repository.
      #
      # **See Also:**
      # - [https://developer.github.com/v3/repos/releases/#list-releases-for-a-repository](https://developer.github.com/v3/repos/releases/#list-releases-for-a-repository)
      def releases(path, **options)
        paginate RepositoryRelease, "#{Repository.path(path)}/releases", **options
      end

      # Create a release
      #
      # **See Also:**
      # - [ https://developer.github.com/v3/repos/releases/#create-a-release]( https://developer.github.com/v3/repos/releases/#create-a-release)
      def create_release(repo, tag_name, **options)
        options = options.merge({tag_name: tag_name})
        res = post "#{Repository.path(path)}/releases", {json: options}
        RepositoryRelease.from_json(res)
      end

      # Get a release
      #
      # **See Also:**
      # - [ https://developer.github.com/v3/repos/releases/#create-a-release]( https://developer.github.com/v3/repos/releases/#create-a-release)
      def release(repo, id)
        res = get "#{Repository.path(repo)}/releases/#{id}"
        RepositoryRelease.from_json(res)
      end

      # Update a release
      #
      # **See Also:**
      # - [ https://developer.github.com/v3/repos/releases/#edit-a-release]( https://developer.github.com/v3/repos/releases/#edit-a-release)
      def update_release(repo, id, **options)
        res = patch "#{Repository.path(path)}/releases/#{id}", {json: options}
        RepositoryRelease.from_json(res)
      end

      # Delete a release
      #
      # **See Also:**
      # - [ https://developer.github.com/v3/repos/releases/#delete-a-release]( https://developer.github.com/v3/repos/releases/#delete-a-release)
      def delete_release(repo, id, **options)
        boolean_from_response :delete, "#{Repository.path(path)}/releases/#{id}"
      end

      # List release assets
      #
      # **See Also:**
      # - [ https://developer.github.com/v3/repos/releases/#list-assets-for-a-release]( https://developer.github.com/v3/repos/releases/#list-assets-for-a-release)
      def release_assets(repo, id, **options)
        paginate RepositoryRelease, "#{Repository.path(repo)}/releases/#{id}/assets", **options
      end

      # Upload a release asset
      #
      # TODO: Get this to work
      #
      # **See Also:**
      # - [ https://developer.github.com/v3/repos/releases/#upload-a-release-asset]( https://developer.github.com/v3/repos/releases/#upload-a-release-asset)
      def upload_asset(repo, id, path_or_file, **options)
        file = path_or_file.is_a?(File) ? path_or_file : File.new(path_or_file, "rb")
        filename = File.basename(file.path)
        content_type = options[:content_type]? || MIME.from_filename(filename)
        raise Octokit::Error::MissingContentType.new if content_type.nil?
        unless name = options[:name]?
          name = filename
        end

        upload_url = release(repo, id).upload_url.split('/')[0..-2].join('/')
        upload_uri = URI.parse(upload_url)
        upload_uri.query = HTTP::Params.encode({name: name})

        headers = {"content-type": content_type, "content-length": file.size}
        options = Halite::Options.new(headers: headers, raw: file.gets_to_end)

        response = request :post, upload_uri.to_s, options
        ReleaseAsset.from_json(response)
      end

      # Get a single release asset
      #
      # **See Also:**
      # - [ https://developer.github.com/v3/repos/releases/#get-a-single-release-asset]( https://developer.github.com/v3/repos/releases/#get-a-single-release-asset)
      def release_asset(repo, id)
        res = get "#{Repository.path(repo)}/releases/assets/#{id}"
        ReleaseAsset.from_json(res)
      end

      # Update a release asset
      #
      # **See Also:**
      # - [ https://developer.github.com/v3/repos/releases/#edit-a-release-asset]( https://developer.github.com/v3/repos/releases/#edit-a-release-asset)
      def update_release_asset(repo, id, **options)
        res = patch "#{Repository.path(repo)}/releases/assets/#{id}", {json: options}
        ReleaseAsset.from_json(res)
      end

      # Delete a release asset
      #
      # **See Also:**
      # - [ https://developer.github.com/v3/repos/releases/#delete-a-release-asset]( https://developer.github.com/v3/repos/releases/#delete-a-release-asset)
      def delete_release_asset(repo, id)
        boolean_from_response :delete, "#{Repository.path(repo)}/releases/assets/#{id}"
      end

      # Get the releases for a given tag
      #
      # **See Also:**
      # - [ https://developer.github.com/v3/repos/releases/#get-a-release-by-tag-name]( https://developer.github.com/v3/repos/releases/#get-a-release-by-tag-name)
      def release_for_tag(repo, tag_name)
        res = get "#{Repository.path(repo)}/releases/tags/#{tag_name}"
        RepositoryRelease.from_json(res)
      end

      # Get the latest release
      #
      # **See Also:**
      # - [ https://developer.github.com/v3/repos/releases/#get-the-latest-release]( https://developer.github.com/v3/repos/releases/#get-the-latest-release)
      def latest_release(repo)
        res = get "#{Repository.path(repo)}/releases/latest"
        RepositoryRelease.from_json(res)
      end
    end
  end
end
