module Octokit
  module Models
    struct ActivityNotifications
      FIELDS = {
        id:         String,
        repository: Repository,
        subject:    NotificationSubject,

        # Reason idntifies the event that triggered the notification.
        #
        # GitHub API docs: https://developer.github.com/v3/activity/notifications/#notification-reasons
        reason: String,

        unread:       Bool,
        updated_at:   String, # TODO: Create converter for 2014-11-07T22:01:45Z
        last_read_at: String,
        url:          String,
      }

      rest_model(FIELDS)

      struct NotificationSubject
        FIELDS = {
          title:              String,
          url:                String,
          latest_comment_url: String,
          type:               String,
        }

        rest_model(FIELDS)
      end

      struct NotificationListOptions
        FIELDS = {
          all:           Bool,
          participating: Bool,
          since:         String,
          before:        String,
        }.merge(ListOptions)

        rest_model(FIELDS)
      end
    end
  end
end
