# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        class HaveAttrWriter
          ##
          # @param attr_name [String, Symbol]
          # @return [void]
          #
          def initialize(attr_name)
            @attr_name = attr_name
          end

          ##
          # @param object [Object] Can be any object.
          # @return [Boolean]
          #
          # @internal
          #   IMPORTANT: A copy is created in order to be thread safe.
          #
          def matches?(object)
            @object = object

            Utils.with_one_time_object do |one_time_object|
              copy = object.dup

              return false if Utils.safe_send(copy, attr_writer_name, one_time_object) != one_time_object
              return false if copy.instance_variable_get(instance_variable_name) != one_time_object

              true
            end
          end

          ##
          # @return [String]
          #
          def description
            "have attr writer `#{attr_name}`"
          end

          ##
          # @return [String]
          #
          def failure_message
            "expected `#{object.class}` to have attr writer `#{attr_name}`"
          end

          ##
          # @return [String]
          #
          def failure_message_when_negated
            "expected `#{object.class}` NOT to have attr writer `#{attr_name}`"
          end

          private

          ##
          # @!attribute [r] object
          #   @return [Object] Can be any type.
          #
          attr_reader :object

          ##
          # @!attribute [r] attr_name
          #   @return [String, Symbol]
          #
          attr_reader :attr_name

          ##
          # @return [String]
          #
          def instance_variable_name
            "@#{attr_name}"
          end

          ##
          # @return [String]
          #
          def attr_writer_name
            "#{attr_name}="
          end
        end
      end
    end
  end
end
