# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        class HaveAttrAccessor
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

            return false unless matches_attr_reader?
            return false unless matches_attr_writer?

            true
          end

          ##
          # @return [String]
          #
          def description
            "have attr accessor `#{attr_name}`"
          end

          ##
          # @return [String]
          #
          def failure_message
            "expected `#{object.class}` to have attr accessor `#{attr_name}`"
          end

          ##
          # @return [String]
          #
          def failure_message_when_negated
            "expected `#{object.class}` NOT to have attr accessor `#{attr_name}`"
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
          # @return [Boolean]
          #
          def matches_attr_reader?
            Classes::HaveAttrReader.new(attr_name).matches?(object)
          end

          ##
          # @return [Boolean]
          #
          def matches_attr_writer?
            Classes::HaveAttrWriter.new(attr_name).matches?(object)
          end
        end
      end
    end
  end
end
