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
        class HaveAttrWriter
          def initialize(attr_name)
            @attr_name = attr_name
          end

          def matches?(object)
            @object = object

            ##
            # IMPORTANT: A copy is created in order to be thread safe.
            #
            copy = object.dup

            copy.public_send("#{attr_name}=", :custom_value)

            copy.instance_variable_get("@#{attr_name}") == :custom_value
          end

          def description
            "have attr writer `#{attr_name}`"
          end

          def failure_message
            "expected `#{object.class}` to have attr writer `#{attr_name}`"
          end

          def failure_message_when_negated
            "expected `#{object.class}` NOT to have attr writer `#{attr_name}`"
          end

          private

          attr_reader :object, :attr_name
        end
      end
    end
  end
end
