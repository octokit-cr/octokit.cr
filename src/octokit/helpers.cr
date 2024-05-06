require "json_mapping"

module Octokit
  # writes basic initializer from properti maps used by JSON.mapping
  # if a `mustbe` field is present for the value, the initializer will set the
  # instance variable to the given value
  macro initializer_for(properties)
    {% for key, value in properties %}
      {% properties[key] = {type: value} unless value.is_a?(NamedTupleLiteral) %}
    {% end %}


    {% for key, value in properties %}
      {% if value[:mustbe] || value[:mustbe] == false %}
        @{{key.id}} : {{value[:type]}}
      {% end %}
    {% end %}
    def initialize(
      {% for key, value in properties %}
        {% if !value[:nilable] && !value[:mustbe] && value[:mustbe] != false %}
          @{{key.id}} : {{ (value[:nilable] ? "#{value[:type]}? = nil, " : "#{value[:type]},").id }}
        {% end %}
      {% end %}
      {% for key, value in properties %}
        {% if value[:nilable] && !value[:mustbe] && value[:mustbe] != false %}
          @{{key.id}} : {{ (value[:nilable] ? "#{value[:type]}? = nil, " : "#{value[:type]},").id }}
        {% end %}
      {% end %}
      )
      {% for key, value in properties %}
        {% if value[:mustbe] || value[:mustbe] == false %}
          @{{key.id}} = {{value[:mustbe]}}
        {% end %}
      {% end %}
    end
  end

  macro initializer_for(**properties)
    Octokit.initializer_for({{properties}})
  end

  macro rest_model(fields)
    JSON.mapping({{fields}})
    Octokit.initializer_for({{fields}})
  end

  macro rest_model(**fields)
    Octokit.rest_model({{fields}})
  end
end
