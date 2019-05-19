# Duplicate a method under a different name.
#
# Yes, I know that aliasing methods is considered "bad practice"
# in Crystal, but as I am trying to replicate the Octokit Ruby
# API as closely as possible (minus a few improvements) I
# figured I could make an exception here.
macro alias_method(from, to, nodoc = true)
  {% for method in @type.methods %}
    {% if method.class_name == "Def" %}
      {% if method.name.id.symbolize == from.id.symbolize %}
        {% if nodoc %}# :nodoc: {% end %}
        def {{ to.id }}(
          {% for arg, i in method.args %}
            {% if method.splat_index == i %}
              *,
            {% else %}
              {{arg.name}}{% if arg.internal_name != arg.name %} {{ arg.internal_name }}{% end %}{% if arg.restriction %} : {{ arg.restriction }}{% end %},
            {% end %}
          {% end %}
          {% if method.double_splat %}
            **{{ method.double_splat }},
          {% end %}
          {% if method.accepts_block? %}
            {% if method.block_arg %}
              {{ method.block_arg }}
            {% else %}
              &block
            {% end %}
          {% end %}
        )
          {{ method.body }}
        end
      {% end %}
    {% end %}
  {% end %}
end
