module Octokit
  module Models
    struct Activity
      FIELDS = {
        timeline_url:                   String,
        user_url:                       String,
        current_user_public_url:        String,
        current_user_url:               String,
        current_user_actor_url:         String,
        current_user_organization_url:  String,
        current_user_organization_urls: Array(String),
      }

      rest_model(FIELDS)

      struct FeedLink
        FIELDS = {
          href: String,
          type: String,
        }

        rest_model(FIELDS)
      end

      struct Links
        FIELDS = {
          timeline:                   FeedLink,
          user:                       FeedLink,
          current_user_public:        FeedLink,
          current_user:               FeedLink,
          current_user_actor:         FeedLink,
          current_user_organization:  FeedLink,
          current_user_organizations: FeedLink,
        }

        rest_model(FIELDS)
      end
    end
  end
end
