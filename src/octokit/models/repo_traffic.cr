module Octokit
  module Models
    struct TrafficReferrer
      rest_model(
        referrer: String,
        count: Int32,
        uniques: Int32
      )
    end

    struct TrafficPath
      rest_model(
        path: String,
        title: String,
        count: Int32,
        uniques: Int32
      )
    end

    struct TrafficData
      rest_model(
        timestamp: String,
        count: Int32,
        uniques: Int32
      )
    end

    struct TrafficViews
      rest_model(
        views: Array(TrafficData),
        count: Int32,
        uniques: Int32
      )
    end

    struct TrafficClones
      rest_model(
        clones: Array(TrafficData),
        count: Int32,
        uniques: Int32
      )
    end

    struct TrafficBreakdownOptions
      rest_model(
        per: String
      )
    end
  end
end
