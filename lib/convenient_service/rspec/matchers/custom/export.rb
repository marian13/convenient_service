# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class Export
          ##
          # @param method_name [Symbol, String]
          # @param scope [Symbol]
          # @return [void]
          #
          def initialize(method_name, scope: :instance)
            @method_name = method_name
            @scope = scope
          end

          ##
          # @param container [Class, Module]
          # @return [Boolean]
          #
          def matches?(container)
            @container = container

            Utils::Bool.to_bool(container.exported_methods.find_by(full_name: method_name, scope: scope))
          end

          ##
          # @return [String]
          #
          def description
            "export `#{method_name}` with scope `#{scope}`"
          end

          ##
          # @return [String]
          #
          def failure_message
            "expected `#{container.class}` to have exported `#{method_name}` with scope `#{scope}`"
          end

          ##
          # @return [String]
          #
          def failure_message_when_negated
            "expected `#{container.class}` NOT to have exported `#{method_name}` with scope `#{scope}`"
          end

          private

          ##
          # @!attribute [r] method_name
          #   @return [Symbol, String]
          #
          attr_reader :method_name

          ##
          # @!attribute [r] scope
          #   @return [Symbol]
          #
          attr_reader :scope

          ##
          # @!attribute [r] container
          #   @return [Class, Module]
          #
          attr_reader :container
        end
      end
    end
  end
end
