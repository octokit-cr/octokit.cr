module Octokit
  module Preview
    PREVIEW_TYPES = {
      "branch_protection"   => "application/vnd.github.loki-preview+json",
      "checks"              => "application/vnd.github.antiope-preview+json",
      "commit_search"       => "application/vnd.github.cloak-preview+json",
      "migrations"          => "application/vnd.github.wyandotte-preview+json",
      "licenses"            => "application/vnd.github.drax-preview+json",
      "source_imports"      => "application/vnd.github.barred-rock-preview",
      "reactions"           => "application/vnd.github.squirrel-girl-preview",
      "transfer_repository" => "application/vnd.github.nightshade-preview+json",
      "issue_timelines"     => "application/vnd.github.mockingbird-preview+json",
      "nested_teams"        => "application/vnd.github.hellcat-preview+json",
      "pages"               => "application/vnd.github.mister-fantastic-preview+json",
      "projects"            => "application/vnd.github.inertia-preview+json",
      "traffic"             => "application/vnd.github.spiderman-preview",
      "integrations"        => "application/vnd.github.machine-man-preview+json",
      "topics"              => "application/vnd.github.mercy-preview+json",
      "community_profile"   => "application/vnd.github.black-panther-preview+json",
      "strict_validation"   => "application/vnd.github.speedy-preview+json",
      "drafts"              => "application/vnd.github.shadow-cat-preview",
    }
  end
end
