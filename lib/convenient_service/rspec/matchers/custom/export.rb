# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class Export
          ##
          # @param full_name [Symbol, String]
          # @param scope [Symbol]
          # @return [void]
          #
          def initialize(full_name, scope: :instance)
            @full_name = full_name
            @scope = scope
          end

          ##
          # @param container [Module]
          # @return [Boolean]
          #
          def matches?(container)
            @container = container

            Utils::Bool.to_bool(container.exported_methods.find_by(full_name: full_name, scope: scope))
          end

          ##
          # @return [String]
          #
          def description
            "export `#{full_name}` with scope `#{scope}`"
          end

          ##
          # @return [String]
          #
          def failure_message
            "expected `#{container.class}` to export `#{full_name}` with scope `#{scope}`"
          end

          ##
          # @return [String]
          #
          def failure_message_when_negated
            "expected `#{container.class}` NOT to export `#{full_name}` with scope `#{scope}`"
          end

          private

          ##
          # @!attribute [r] full_name
          #   @return [Symbol, String]
          #
          attr_reader :full_name

          ##
          # @!attribute [r] scope
          #   @return [Symbol]
          #
          attr_reader :scope

          ##
          # @!attribute [r] container
          #   @return [Module]
          #
          attr_reader :container
        end
      end
    end
  end
end
