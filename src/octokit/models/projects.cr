module Octokit
  module Models
    struct Project
      rest_model(
        id: Int64,
        url: String,
        html_url: String,
        columns_url: String,
        name: String,
        body: String,
        number: Int32,
        state: String,
        created_at: String,
        updated_at: String,
        node_id: String,

        creator: User
      )
    end

    struct ProjectOptions
      rest_model(
        name: String,

        body: String,

        state: String,

        organization_permission: String,

        public: Bool
      )
    end

    struct ProjectColumn
      rest_model(
        id: Int64,
        name: String,
        url: String,
        projects_url: String,
        cards_url: String,
        created_at: Timestamp,
        updated_at: Timestamp,
        node_id: String
      )
    end

    struct ProjectColumnOptions
      rest_model(
        name: String
      )
    end

    struct ProjectColumnMoveOptions
      rest_model(
        position: String
      )
    end

    struct ProjectCard
      rest_model(
        url: String,
        columns_url: String,
        content_url: String,
        id: Int64,
        note: String,
        creator: User,
        created_at: Timestamp,
        updated_at: Timestamp,
        node_id: String,
        archived: Bool,

        column_id: Int64?,

        project_id: Int64?,
        project_url: String?,
        column_name: String?,
        previous_column_name: String?
      )
    end

    struct ProjectCardListOptions
      rest_model({
        archived_state: String
      }.merge(ListOptions::FIELDS))
    end

    struct ProjectCardOptions
      rest_model(
        note: String,
        
        content_id: Int64,

        content_type: String,

        archived: Bool
      )
    end

    struct ProjectCardMoveOptions
      rest_model(
        position: String,
        column_id: Int64
      )
    end

    struct ProjectCollaboratorOptions
      rest_model(
        permission: String
      )
    end

    struct ListCollaboratorOptions
      rest_model({
        affiliation: String
      }.merge(ListOptions::FIELDS))
    end

    struct ProjectPermissionLevel
      rest_model(
        permission: String,
        user: User
      )
    end
  end
end
