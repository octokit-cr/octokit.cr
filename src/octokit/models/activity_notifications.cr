module Octokit
  module Models
    struct ActivityNotifications
      Octokit.rest_model(
        id: String,
        repository: Repository,
        subject: NotificationSubject,

        # Reason idntifies the event that triggered the notification.
        #
        # GitHub API docs: https://developer.github.com/v3/activity/notifications/#notification-reasons
        reason: String,

        unread: Bool,
        updated_at: {type: Time, converter: Time::ISO8601Converter}, # TODO: Create converter for 2014-11-07T22:01:45Z
        last_read_at: String,
        url: String
      )

      struct NotificationSubject
        Octokit.rest_model(
          title: String,
          url: String,
          latest_comment_url: String,
          type: String
        )
      end

      struct NotificationListOptions
        Octokit.rest_model({
          all:           Bool,
          participating: Bool,
          since:         String,
          before:        String,
          # }.merge(ListOptions::FIELDS))
        })
      end
    end
  end
end
