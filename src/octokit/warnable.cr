module Octokit
  # Allows warnings to be suppressed via environment variable.
  module Warnable
    # Wrapper around Logger.warn to print warnings unless
    # OCTOKIT_SILENT is set to true.
    def octokit_warn(message)
      unless !!ENV["OCTOKIT_SILENT"]?
        Octokit.logger.warn(message)
      end
    end
  end
end
