# frozen_string_literal: true

##
# Usage example:
#
#   ConvenientService::Utils::Object::ResolveType.call("foo")
#   # => "instance"
#
#   ConvenientService::Utils::Object::ResolveType.call(Array)
#   # => "class"
#
#   ConvenientService::Utils::Object::ResolveType.call(Kernel)
#   # => "module"
#
module ConvenientService
  module Utils
    module Object
      class ResolveType < Support::Command
        attr_reader :object

        def initialize(object)
          @object = object
        end

        def call
          case object
          when ::Class
            "class"
          when ::Module
            "module"
          else
            "instance"
          end
        end
      end
    end
  end
end
