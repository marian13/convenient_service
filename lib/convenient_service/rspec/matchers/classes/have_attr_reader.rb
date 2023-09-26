# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        ##
        # TODO: Specs.
        #
        class HaveAttrReader
          def initialize(attr_name)
            @attr_name = attr_name
          end

          def matches?(object)
            @object = object

            ##
            # IMPORTANT: A copy is created in order to be thread safe.
            #
            copy = object.dup

            copy.instance_variable_set("@#{attr_name}", :custom_value)

            copy.public_send(attr_name) == :custom_value
          end

          def description
            "have attr reader `#{attr_name}`"
          end

          def failure_message
            "expected `#{object.class}` to have attr reader `#{attr_name}`"
          end

          def failure_message_when_negated
            "expected `#{object.class}` NOT to have attr reader `#{attr_name}`"
          end

          private

          attr_reader :object, :attr_name
        end
      end
    end
  end
end
