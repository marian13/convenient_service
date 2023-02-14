# frozen_string_literal: true

require_relative "export/container"

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class Export
          include ConvenientService::DependencyContainer::Import

          import :"DependencyContainer::Constants", scope: :class, from: Container
          import :"DependencyContainer::Errors", from: Container

          include DependencyContainer::Constants

          ##
          # @param full_name [Symbol, String]
          # @param scope [Symbol]
          # @return [void]
          #
          def initialize(full_name, scope: DEFAULT_SCOPE)
            @full_name = full_name
            @scope = scope
          end

          ##
          # @param container [Module]
          # @return [Boolean]
          #
          def matches?(container)
            @container = container

            raise DependencyContainer::Errors::NotExportableModule.new(mod: container) unless Utils::Module.include_module?(container, DependencyContainer::Export)

            raise DependencyContainer::Errors::InvalidScope.new(scope: scope) unless SCOPES.include?(scope)

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
