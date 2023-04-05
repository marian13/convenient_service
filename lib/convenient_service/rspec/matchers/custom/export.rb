# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class Export
          include ConvenientService::DependencyContainer::Import

          import :"constants.DEFAULT_SCOPE", from: ConvenientService::Support::DependencyContainer::Container
          import :"commands.AssertValidContainer", from: ConvenientService::Support::DependencyContainer::Container
          import :"commands.AssertValidScope", from: ConvenientService::Support::DependencyContainer::Container

          ##
          # @param full_name [Symbol, String]
          # @param scope [Symbol]
          # @return [void]
          #
          def initialize(full_name, scope: constants.DEFAULT_SCOPE)
            @full_name = full_name
            @scope = scope
          end

          ##
          # @param container [Module]
          # @return [Boolean]
          #
          def matches?(container)
            @container = container

            commands.AssertValidContainer.call(container: container)

            commands.AssertValidScope.call(scope: scope)

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
            "expected `#{container}` to export `#{full_name}` with scope `#{scope}`"
          end

          ##
          # @return [String]
          #
          def failure_message_when_negated
            "expected `#{container}` NOT to export `#{full_name}` with scope `#{scope}`"
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
