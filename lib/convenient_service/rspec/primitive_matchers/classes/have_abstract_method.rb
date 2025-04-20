# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        class HaveAbstractMethod
          def initialize(method_name)
            @method_name = method_name
          end

          def matches?(object)
            @object = object

            begin
              object.__send__(method_name)

              false
            rescue ConvenientService::Support::AbstractMethod::Exceptions::AbstractMethodNotOverridden
              true
            rescue
              false
            end
          end

          def description
            "have abstract method `#{method_name}`"
          end

          def failure_message
            "expected `#{object.class}` to have abstract method `#{method_name}`"
          end

          def failure_message_when_negated
            "expected `#{object.class}` NOT to have abstract method `#{method_name}`"
          end

          private

          attr_reader :object, :method_name
        end
      end
    end
  end
end
