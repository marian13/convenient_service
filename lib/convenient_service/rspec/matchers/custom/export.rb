# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class Export
          def initialize(method_name, scope: :instance)
            @method_name = method_name
            @scope = scope
          end

          def matches?(container)
            @container = container

            Utils::Bool.to_bool(container.exported_methods.find_by(full_name: method_name, scope: scope))
          end

          def description
            "export `#{method_name}` with scope `#{scope}`"
          end

          def failure_message
            "expected `#{container.class}` to have export `#{method_name}` with scope `#{scope}`"
          end

          def failure_message_when_negated
            "expected `#{container.class}` NOT to have export `#{method_name}` with scope `#{scope}`"
          end

          private

          attr_reader :method_name, :scope, :container
        end
      end
    end
  end
end
