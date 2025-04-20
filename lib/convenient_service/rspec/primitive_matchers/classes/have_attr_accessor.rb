# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        ##
        # TODO: Specs.
        #
        class HaveAttrAccessor
          def initialize(attr_name)
            @attr_name = attr_name
          end

          def matches?(object)
            @object = object

            Classes::HaveAttrReader.new(attr_name).matches?(object)
            Classes::HaveAttrWriter.new(attr_name).matches?(object)

            true
          end

          def description
            "have attr accessor `#{attr_name}`"
          end

          def failure_message
            "expected `#{object.class}` to have attr accessor `#{attr_name}`"
          end

          def failure_message_when_negated
            "expected `#{object.class}` NOT to have attr accessor `#{attr_name}`"
          end

          private

          attr_reader :object, :attr_name
        end
      end
    end
  end
end
