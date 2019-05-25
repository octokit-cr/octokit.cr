struct Time
  module ISO8601Converter
    def self.to_json(value : Time, json : JSON::Builder)
      json.string(value.to_rfc3339)
    end

    def self.from_json(value : JSON::PullParser) : Time
      Time.parse_iso8601(value.read_string)
    end
  end
end
