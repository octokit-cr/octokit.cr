module Octokit
  class Client
    module Markdown
      # Render an arbitrary Markdown document
      #
      # Example:
      # ```
      # Octokit.markdown("Fixed in #111", mode: :gfm, context: "watzon/cadmium")
      # ```
      def markdown(text, mode = :markdown, context = nil)
        headers = {accept: "application/vnd.github.raw"}
        json = {text: text, mode: mode.to_s, context: context}
        post "markdown", {json: json, headers: headers}
      end
    end
  end
end
