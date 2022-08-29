# frozen_string_literal: true

##
# Usage example:
#
#   module Test
#   end
#
#   ConvenientService::Utils::Object::FindOwnConst.call(Test, :File)
#   # => nil, not File from Ruby Core.
#
#   module Test
#     class File
#     end
#   end
#
#   ConvenientService::Utils::Object::FindOwnConst.call(Test, :File)
#   # => Test::File
#
module ConvenientService
  module Utils
    module Object
      class FindOwnConst < Support::Command
        attr_reader :object, :const_name

        def initialize(object, const_name)
          @object = object
          @const_name = const_name
        end

        def call
          ##
          # NOTE: > If `inherit' is `false', the lookup only checks the constants in the receiver:
          # https://ruby-doc.org/core-3.0.0/Module.html#method-i-const_defined-3F
          #
          return unless object.const_defined?(const_name, false)

          object.const_get(const_name, false)
        end
      end
    end
  end
end
