module Octokit
  module Models
    struct TrafficReferrer
      Octokit.rest_model(
        referrer: String,
        count: Int32,
        uniques: Int32
      )
    end

    struct TrafficPath
      Octokit.rest_model(
        path: String,
        title: String,
        count: Int32,
        uniques: Int32
      )
    end

    struct TrafficData
      Octokit.rest_model(
        timestamp: String,
        count: Int32,
        uniques: Int32
      )
    end

    struct TrafficViews
      Octokit.rest_model(
        views: Array(TrafficData),
        count: Int32,
        uniques: Int32
      )
    end

    struct TrafficClones
      Octokit.rest_model(
        clones: Array(TrafficData),
        count: Int32,
        uniques: Int32
      )
    end

    struct TrafficBreakdownOptions
      Octokit.rest_model(
        per: String
      )
    end
  end
end
