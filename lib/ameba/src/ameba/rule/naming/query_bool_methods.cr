module Ameba::Rule::Naming
  # A rule that disallows boolean properties without the `?` suffix - defined
  # using `Object#(class_)property` or `Object#(class_)getter` macros.
  #
  # Favour this:
  #
  # ```
  # class Person
  #   property? deceased = false
  #   getter? witty = true
  # end
  # ```
  #
  # Over this:
  #
  # ```
  # class Person
  #   property deceased = false
  #   getter witty = true
  # end
  # ```
  #
  # YAML configuration example:
  #
  # ```
  # Naming/QueryBoolMethods:
  #   Enabled: true
  # ```
  class QueryBoolMethods < Base
    include AST::Util

    properties do
      description "Reports boolean properties without the `?` suffix"
    end

    MSG = "Consider using '%s?' for '%s'"

    CALL_NAMES = %w[getter class_getter property class_property]

    def test(source, node : Crystal::ClassDef | Crystal::ModuleDef)
      calls =
        case body = node.body
        when Crystal::Call
          [body] if body.name.in?(CALL_NAMES)
        when Crystal::Expressions
          body.expressions
            .select(Crystal::Call)
            .select!(&.name.in?(CALL_NAMES))
        end

      calls.try &.each do |exp|
        exp.args.each do |arg|
          name_node, is_bool =
            case arg
            when Crystal::Assign
              {arg.target, arg.value.is_a?(Crystal::BoolLiteral)}
            when Crystal::TypeDeclaration
              {arg.var, path_named?(arg.declared_type, "Bool")}
            else
              {nil, false}
            end

          if name_node && is_bool
            issue_for name_node, MSG % {exp.name, name_node}
          end
        end
      end
    end
  end
end
