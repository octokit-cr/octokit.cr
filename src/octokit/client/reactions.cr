require "uri"
require "../models/repos"
require "../models/reactions"

module Octokit
  class Client
    # Methods for the Reactions API
    #
    # All "repo" params are constructed in the format of `<organization>/<repository>`
    #
    # **See Also:**
    # - [https://docs.github.com/en/rest/reactions/reactions](https://docs.github.com/en/rest/reactions/reactions)

    module Reactions
      # :nodoc:
      alias Repository = Models::Repository

      # :nodoc:
      alias Reaction = Models::Reaction

      # List reactions for a commit comment
      #
      # **See Also:**
      # - [https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#list-reactions-for-a-commit-comment](https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#list-reactions-for-a-commit-comment)
      #
      # **Examples:**
      #
      # List all the reactions for a commit comment
      #
      # ```
      # Octokit.commit_comment_reactions("monsalisa/app", 123456)
      # ```
      def commit_comment_reactions(repo : String, id : Int64, **options) : Paginator(Reaction)
        paginate(Reaction, "#{Repository.path(repo)}/comments/#{id}/reactions", **options)
      end

      # Create a reaction for a commit comment
      #
      # **See Also:**
      # - [https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#create-reaction-for-a-commit-comment](https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#create-reaction-for-a-commit-comment)
      #
      # **Examples:**
      #
      # ```
      # Octokit.create_commit_comment_reaction("monsalisa/app", 123456, "+1")
      # ```
      def create_commit_comment_reaction(repo : String, id : Int64, reaction : String, **options) : Reaction
        options = options.merge({json: {content: reaction}})
        Reaction.from_json(post("#{Repository.path(repo)}/comments/#{id}/reactions", options))
      end

      # List reactions for an issue
      #
      # **See Also:**
      # - [https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#list-reactions-for-an-issue](https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#list-reactions-for-an-issue)
      #
      # **Examples:**
      #
      # ```
      # Octokit.issue_reactions("monsalisa/app", 123456)
      # ```
      def issue_reactions(repo : String, number : Int64, **options) : Paginator(Reaction)
        paginate(Reaction, "#{Repository.path(repo)}/issues/#{number}/reactions", **options)
      end

      # Create reaction for an issue
      #
      # **See Also:**
      # - [https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#create-reaction-for-an-issue](https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#create-reaction-for-an-issue)
      #
      # **Examples:**
      #
      # ```
      # Octokit.create_issue_reaction("monsalisa/app", 123456, "heart")
      # ```
      def create_issue_reaction(repo : String, number : Int64, reaction : String, **options) : Reaction
        options = options.merge({json: {content: reaction}})
        Reaction.from_json(post("#{Repository.path(repo)}/issues/#{number}/reactions", options))
      end

      # List reactions for an issue comment
      #
      # **See Also:**
      # - [https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#list-reactions-for-an-issue-comment](https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#list-reactions-for-an-issue-comment)
      #
      # **Examples:**
      #
      # ```
      # reactions = Octokit.issue_comment_reactions("monsalisa/app", 987654)
      # reactions.records.each do |reaction|
      #   puts reaction.content    # --> "+1" (example)
      #   puts reaction.user.login # --> "octocat" (example)
      #   puts reaction.id         # --> 271694398 (example)
      # end
      # ```
      def issue_comment_reactions(repo : String, id : Int64, **options) : Paginator(Reaction)
        paginate(Reaction, "#{Repository.path(repo)}/issues/comments/#{id}/reactions", **options)
      end

      # Create reaction for an issue comment
      #
      # **See Also:**
      # - [https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#create-reaction-for-an-issue-comment](https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#create-reaction-for-an-issue-comment)
      #
      # **Examples:**
      #
      # ```
      # Octokit.create_issue_comment_reaction("monsalisa/app", 987654, "laugh")
      # ```
      def create_issue_comment_reaction(repo : String, id : Int64, reaction : String, **options) : Reaction
        options = options.merge({json: {content: reaction}})
        Reaction.from_json(post("#{Repository.path(repo)}/issues/comments/#{id}/reactions", options))
      end

      # Delete a reaction from an issue comment
      #
      # **IMPORTANT:**
      # - You must be the author of the reaction to delete it.
      # - [https://github.com/orgs/community/discussions/28525#discussioncomment-3370231](https://github.com/orgs/community/discussions/28525#discussioncomment-3370231)
      #
      # **See Also:**
      # - [https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#delete-an-issue-comment-reaction](https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#delete-an-issue-comment-reaction)
      #
      # **Examples:**
      #
      # ```
      # Octokit.delete_issue_comment_reaction("monsalisa/app", 987654, 123)
      # ```
      def delete_issue_comment_reaction(repo : String, comment_id : Int64, reaction_id : Int64, **options) : Bool
        boolean_from_response(:delete, "#{Repository.path(repo)}/issues/comments/#{comment_id}/reactions/#{reaction_id}", **options)
      end

      # List reactions for a pull request review comment
      #
      # **See Also:**
      # - [https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#list-reactions-for-a-pull-request-review-comment](https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#list-reactions-for-a-pull-request-review-comment)
      #
      # **Examples:**
      #
      # ```
      # Octokit.pull_request_review_comment_reactions("monsalisa/app", 555111)
      # ```
      def pull_request_review_comment_reactions(repo : String, id : Int64, **options) : Paginator(Reaction)
        paginate(Reaction, "#{Repository.path(repo)}/pulls/comments/#{id}/reactions", **options)
      end

      # Create reaction for a pull request review comment
      #
      # **See Also:**
      # - [https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#create-reaction-for-a-pull-request-review-comment](https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#create-reaction-for-a-pull-request-review-comment)
      #
      # **Examples:**
      #
      # ```
      # Octokit.create_pull_request_review_comment_reaction("monsalisa/app", 555111, "hooray")
      # ```
      def create_pull_request_review_comment_reaction(repo : String, id : Int64, reaction : String, **options) : Reaction
        options = options.merge({json: {content: reaction}})
        Reaction.from_json(post("#{Repository.path(repo)}/pulls/comments/#{id}/reactions", options))
      end

      # Delete a reaction
      #
      # **See Also:**
      # - [https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#delete-an-issue-reaction](https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#delete-an-issue-reaction)
      #
      # **Examples:**
      #
      # ```
      # Octokit.delete_issue_reaction("monsalisa/app", 987654, 123)
      # ```
      def delete_issue_reaction(repo : String, issue_id : Int64, reaction_id : Int64, **options) : Bool
        boolean_from_response(:delete, "#{Repository.path(repo)}/issues/#{issue_id}/reactions/#{reaction_id}", **options)
      end

      # List reactions for a release
      #
      # **See Also:**
      # - [https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#list-reactions-for-a-release](https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#list-reactions-for-a-release)
      #
      # **Examples:**
      #
      # ```
      # Octokit.release_reactions("monsalisa/app", 987654)
      # ```
      def release_reactions(repo : String, release_id : Int64, **options) : Paginator(Reaction)
        paginate(Reaction, "#{Repository.path(repo)}/releases/#{release_id}/reactions", **options)
      end

      # Create reaction for a release
      #
      # **See Also:**
      # - [https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#create-reaction-for-a-release](https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#create-reaction-for-a-release)
      #
      # **Examples:**
      #
      # ```
      # Octokit.create_release_reaction("monsalisa/app", 987654, "heart")
      # ```
      def create_release_reaction(repo : String, release_id : Int64, reaction : String, **options) : Reaction
        options = options.merge({json: {content: reaction}})
        Reaction.from_json(post("#{Repository.path(repo)}/releases/#{release_id}/reactions", options))
      end

      # Delete a reaction for a release
      #
      # **See Also:**
      # - [https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#delete-a-release-reaction](https://docs.github.com/en/rest/reactions/reactions?apiVersion=2022-11-28#delete-a-release-reaction)
      #
      # **Examples:**
      #
      # ```
      # Octokit.delete_release_reaction("monsalisa/app", 987654, 123)
      # ```
      def delete_release_reaction(repo : String, release_id : Int64, reaction_id : Int64, **options) : Bool
        boolean_from_response(:delete, "#{Repository.path(repo)}/releases/#{release_id}/reactions/#{reaction_id}", **options)
      end
    end
  end
end
