module Octokit
    class Client
      module Labels
          alias Repository = Models::Repository
          # alias Issue = Models::Issue
  
          #List labels assigned to an issue based on https://docs.github.com/en/rest/reference/issues#list-labels-for-an-issue
          def labels
              path = repo ? "#{Repository.path(repo)}/issues/#{issue_number}/labels" : "incorrect path"
          end
  
  
      end
    end
  end