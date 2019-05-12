module Octokit
  module Models
    struct Import
      Octokit.rest_model(
        vcs_url: String,

        vcs: String,

        vcs_username: String?,
        vcs_password: String?,

        tfvc_project: String?,

        use_lfs: String,

        has_large_files: Bool,

        large_file_size: Int32,

        large_files_count: Int32,

        status: String,
        commit_count: Int32,
        status_text: String,
        authors_count: Int32,
        percent: Int32,
        push_percent: Int32,
        url: String,
        html_url: String,
        authors_url: String,
        repository_url: String,
        message: String,
        failed_step: String,

        human_name: String?,

        project_choices: Array(Import)
      )
    end

    struct SourceImportAuthor
      Octokit.rest_model(
        id: Int64,
        remote_id: String,
        remote_name: String,
        email: String,
        name: String,
        url: String,
        import_url: String
      )
    end

    struct LargeFile
      Octokit.rest_model(
        ref_name: String,
        path: String,
        oid: String,
        size: Int32
      )
    end
  end
end
