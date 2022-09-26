# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        ##
        # TODO: Specs.
        #
        class HaveAttrAccessor
          def initialize(attr_name)
            @attr_name = attr_name
          end

          def matches?(object)
            @object = object

            Custom::HaveAttrReader.new(attr_name).matches?(object)
            Custom::HaveAttrWriter.new(attr_name).matches?(object)

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
