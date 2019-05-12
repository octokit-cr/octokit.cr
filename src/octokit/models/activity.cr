module Octokit
  module Models
    struct Activity
      Octokit.rest_model(
        timeline_url:                   String,
        user_url:                       String,
        current_user_public_url:        String,
        current_user_url:               String,
        current_user_actor_url:         String,
        current_user_organization_url:  String,
        current_user_organization_urls: Array(String)
      )

      struct FeedLink
        Octokit.rest_model(
          href: String,
          type: String
        )
      end

      struct Links
        Octokit.rest_model(
          timeline:                   FeedLink,
          user:                       FeedLink,
          current_user_public:        FeedLink,
          current_user:               FeedLink,
          current_user_actor:         FeedLink,
          current_user_organization:  FeedLink,
          current_user_organizations: FeedLink
        )
      end
    end
  end
end
