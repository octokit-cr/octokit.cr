module Octokit
  class Client
    # Methods for the unpublished Octocat API
    module Say
      # Return a nifty ASCII Octocat with GitHub wisdom
      # or your own
      def say(text = nil)
        get "octocat", {params: {s: text}}
      end

      alias_method :say, :octocat
    end
  end
end
